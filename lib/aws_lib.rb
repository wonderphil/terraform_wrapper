module AwsLib

  require 'aws-sdk'
  require 'colorize'


  def check_session(profile, region)
    #Takes in t vars and checks if standard aws creds are vaild for that region and profile 
    if profile.nil?
      puts "ERROR - Environment must be set".red
      exit 1
    else
      begin
        a = Aws::STS::Client.new({profile: profile, region: region})
        a.get_caller_identity({})
      rescue Aws::Errors::ServiceError, Aws::Errors::MissingCredentialsError => e
        puts "ERROR - AWS Creds are not valid.".red
        puts "#{e}".red
        exit 1
      end
    end
  end

  def s3_check(profile, region, bucket)
    #just checks if bucket is there or not
    aws_s3_res = Aws::S3::Resource.new(region: region, profile: profile)
    aws_s3_res.bucket(bucket).exists?
  end



end