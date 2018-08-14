module RubyUtils
  require 'colorize'

  def check_folder?(folder, *non_exist)
    if non_exist.any?
      if non_exist[0] == true
        if Dir.exist?(folder)  == true 
          puts ("ERROR - The following folder exists: " + folder).red
        end
      end
    else
      if Dir.exist?(folder)  == false 
        puts ("ERROR - Can find the following folder: " + folder).red
        exit 1
      end
    end
  end

  def check_file(path)
    if File.file?(path) != true
      puts "ERROR - File doesn't not exist! looking for #{path}".red
      exit 1
    end
  end


end