module Craken

  require 'socket'

  HOSTNAME          = Socket.gethostname.split(/\./)[0].downcase.strip
  DEPLOY_PATH       = ENV['deploy_path'] || RAILS_ROOT
  if ENV['raketab_file']
    RAKETAB_FILE    = ENV['raketab_file']
  elsif File.directory?("#{DEPLOY_PATH}/config/craken/") # Use hostname specific raketab first.
    RAKETAB_FILE    = File.exists?("#{DEPLOY_PATH}/config/craken/#{HOSTNAME}_raketab") ? "#{DEPLOY_PATH}/config/craken/#{HOSTNAME}_raketab" : "#{DEPLOY_PATH}/config/craken/raketab"
  else
    RAKETAB_FILE    = "#{DEPLOY_PATH}/config/raketab"
  end
  CRONTAB_EXE       = ENV['crontab_exe'] || "/usr/bin/crontab"
  RAKE_EXE          = ENV['rake_exe'] || (rake = `which rake`.strip and rake.empty?) ? "/usr/bin/rake" : rake
  RAKETAB_RAILS_ENV = ENV['raketab_rails_env'] || RAILS_ENV
  # assumes root of app is name of app, also takes into account 
  # capistrano deployments
  APP_NAME          = ENV['app_name'] || (DEPLOY_PATH =~ /\/([^\/]*)\/releases\/\d*$/ ? $1 : File.basename(DEPLOY_PATH))

  # strip out the existing raketab cron tasks for this project
  def load_and_strip
    crontab = ''
    old = false
    `#{CRONTAB_EXE} -l`.each_line do |line|
      line.strip!
      if old || line == "### #{APP_NAME} raketab"
        old = line != "### #{APP_NAME} raketab end"
      else
        crontab << line
        crontab << "\n"
      end
    end
    crontab
  end

  def append_tasks(crontab, raketab)
    crontab << "### #{APP_NAME} raketab\n"
    raketab.each_line do |line|
      line.strip!
      unless line =~ /^#/ || line.empty? # ignore comments and blank lines
        sp = line.split
        crontab << sp[0,5].join(' ')
        crontab << " cd #{DEPLOY_PATH} && #{RAKE_EXE} --silent RAILS_ENV=#{RAKETAB_RAILS_ENV}"
        sp[5,sp.size].each do |task|
          crontab << " #{task}"
        end
        crontab << "\n"
      end
    end
    crontab << "### #{APP_NAME} raketab end\n"
    crontab
  end

  # install new crontab
  def install(crontab)
    filename = ".crontab#{rand(9999)}" 
    File.open(filename, 'w') { |f| f.write crontab }
    `#{CRONTAB_EXE} #{filename}`
    FileUtils.rm filename
  end

end
