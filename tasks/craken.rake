require "#{File.dirname(__FILE__)}/../lib/craken"

namespace :craken do

  desc "Install raketab script"
  task :install do
    require 'erb'
    include Craken
    if File.exists? RAKETAB_FILE
      puts "craken:install => Using raketab file #{RAKETAB_FILE}"
      #raketab = File.read RAKETAB_FILE
      raketab = ERB.new(File.read(RAKETAB_FILE)).result(binding)
      crontab = append_tasks(load_and_strip, raketab)
      install crontab
    end
  end

  desc "Uninstall cron jobs associated with application"
  task :uninstall do
    include Craken
    # install stripped cron
    install load_and_strip
  end

end
