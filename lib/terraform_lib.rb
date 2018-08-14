module TerraformLib
  require 'colorize'
  require_relative 'aws_lib'
  require 'date'
  require 'etc'

  def check_tf_version(current_version)
    puts "Checking current system has correct version of terraform for config".magenta
    puts "The current version of terraform for this config is: ".magenta + "#{current_version}".green
    system_version = (`terraform version`).match(/\d+.\d+.\d+/).to_s.gsub(".","").to_i
    current_version = current_version.to_s.gsub(".","").to_i
    if system_version > current_version
      puts "WARNING - Current config was built with lower version of terraform, either downgrade terraform or update config.".red
      puts "System version of terraform is #{system_version}".red
      exit 1
    elsif system_version < current_version
      puts "WARNING - Current config was built with higher version of terraform, please upgrade terraform.".red
      puts "System version of terraform is #{system_version}".red
      exit 1
    elsif system_version != current_version
      puts "ERROR - Something is wrong with either you build config or the version of terraform on the system.".red
      puts "unable to compare require version of terraform and version of installed terraform.".red
    end
  end

  def terraform_ws(env, region, service_dir)
    puts "Creating or changing Workspace to #{env}-#{region}".magenta
    Dir.chdir(service_dir){
      workspaces = `terraform workspace list`.split("\n").collect(&:strip).map!{ |ws| ws.gsub(/\*\s+/, '') }
      if !workspaces.include?("#{env}-#{region}")
        system "terraform workspace new #{env}-#{region}"
      else
        puts "Workspace exists, changing to it now".yellow
        system "terraform workspace select #{env}-#{region}"
      end
    }
  end

  def terraform_init(env, region, service_dir, state_profile='', state_region='', bucket='', file='', init_script='')

    puts "Environment set to: ".magenta + "#{env}".green + " and region is set to ".magenta + "#{region}".green
    if init_script != true
      puts "Terraform state will be synced to ".magenta + "s3://#{bucket}/#{file}".green + " in the Production account.".magenta

      if !AwsLib::s3_check(state_profile, state_region, bucket)
        puts "ERROR - S3 Bucket doesn't exist, You need to run the account setup service to setup aws production account!".red
        exit 1
      end
      puts "****"
      cmd_args = "-backend-config=configs/backend.conf -get=true"
    else
      cmd_args = "-get=true"
    end

    Dir.chdir(service_dir){
      system "terraform init #{cmd_args}"
      terraform_ws(env, region, service_dir)
      #TODO - Is this the correct command to run
      #system "terraform init -get=true -backend-config=config/backend.conf -var-file=config/#{new_env}-#{region}-terraform.tfvars -var-file=#{shared_config}"

      #TODO - Does this need to be here
      #system "terraform workspace select #{env}"
    }
    puts 'Terraform init completed'.magenta
  end

  def terraform_get(env, region, service_dir)
    puts "Environment set to: ".magenta + "#{env}".green + " and region is set to ".magenta + "#{region}".green
    Dir.chdir(service_dir){
      system "terraform workspace select #{env}"
      system "terraform get -update=true"
    }
    puts "Terraform get completed".magenta
  end

  def terraform_import(env, region, service_dir, config_hash)
    puts "Environment set to: ".magenta + "#{env}".green + " and region is set to ".magenta + "#{region}".green
    
    puts "What is the resource that you want to import? e.g. this is how its defined in terraform code. ".yellow
    puts "Resource \"aws_vpn_gateway\" \"vpn_gw\" would be aws_vpn_gateway.vpn_gw".yellow
    import_add = (STDIN.gets).chomp

    puts "What is the resource id in aws you want to import? e.g. the id from aws console vgw-ee00329a".yellow 
    import_id = (STDIN.gets).chomp

    cmd_agrs = "import -var-file=#{config_hash["service"]} -var-file=#{config_hash["shared"]} -var-file=#{config_hash["global"]} -var-file=#{config_hash["shared_backend"]} #{import_add} #{import_id}"
    Dir.chdir(service_dir){
      terraform_ws(env, region, service_dir)
      system "terraform #{cmd_agrs}"
    }
    puts "Terraform import completed".magenta
  end

  def terraform_output(service_dir)
    cmd_args = "output -json"
    Dir.chdir(service_dir){
      puts "Running terraform ".magenta + "output".green + " action now:".magenta
      `terraform #{cmd_args}`
    }
  end

  def terraform_other(action, env, region, service_dir, config_hash, auto_approve='', init_script='')
    puts "Environment set to: ".magenta + "#{env}".green + " and region is set to ".magenta + "#{region}".green
    if auto_approve && action == 'apply'
      cmd_args = "#{action} -auto-approve "
    elsif auto_approve && action == 'destroy'
      cmd_args = "#{action} -force "
    else
      cmd_args = "#{action} "
    end

    if init_script != true
      passwords = "#{config_hash["shared_folder"]}/passwords"
      cmd_args = "#{cmd_args} -var-file=#{config_hash["service"]} -var-file=#{config_hash["shared"]} -var-file=#{config_hash["global"]} -var-file=#{config_hash["shared_backend"]}"
      if File.file?(passwords) 
        cmd_args = "#{cmd_args} -var-file=#{passwords}"
      end
    else
      cmd_args = "#{cmd_args} -var-file=#{config_hash["service"]} -var-file=#{config_hash["shared"]}"
    end
    
    Dir.chdir(service_dir){
      terraform_ws(env, region, service_dir)
      puts "Running terraform ".magenta + "#{action}".green + " action now:".magenta
      puts cmd_args
      system "terraform #{cmd_args}"
    }
  end

  def build_tfvars(envs, path, region, team, service, bucket, prod_profile, state_kms)
    envs.each do |env|
      file_path = ("#{path}/#{env}-#{region}-terraform.tfvars")
      open(file_path,"w") { |f|
        f.puts "owners      = \"#{team}\""
        f.puts "service     = \"#{service}\""
        f.puts "environment = \"#{env}\""
        f.puts "aws_region  = \"#{region}\""
      }
    end

    be_file_path = ("#{path}/backend.conf")
    open(be_file_path,"w") { |f|
      f.puts "bucket          = \"#{bucket}\""
      f.puts "key             = \"backend-#{service}-#{region}-terraform.tfstate\""    
      f.puts "profile         = \"#{prod_profile}\""
      f.puts "region          = \"#{region}\""
      f.puts "dynamodb_table  = \"terraform-state\""
      f.puts "encrypt         = true"
      f.puts "kms_key_id      = \"#{state_kms}\""
    }
  end

  def build_files(path, service, des, team)
    readme_path = (path + '/README.md')
    open(readme_path, 'w') do |f|
      f.puts "# #{service} Infrastructure TerraForm"
      f.puts '***'
      f.puts "This builds the requires infrastructure for #{service}."
      f.puts des
      f.puts ' '
      f.puts "**Owning Team:** #{team}"
      f.puts ' '
      f.puts '###This builds:'
      f.puts ' TODO - fill in'
      f.puts ' '
      f.puts '## Dependancy'
      f.puts ' TODO - fill in'
    end

    changelog_path = (path + '/CHANGELOG.md')
    open(changelog_path, 'w') do |f|
      f.puts '# Changelog'
      f.puts ' '
      f.puts 'All notable changes to this project will be documented in this file.'
      f.puts ' '
      f.puts ' '
      f.puts "## 0.0.1 - #{Date.today.to_s}"
      f.puts '### Added'
      f.puts "- Service initiated by #{Etc.getlogin}"
    end


  end

end