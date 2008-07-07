# Runs craken:install on all the app servers.
namespace :craken do
  desc "Install raketab"
  task :install, :roles => :cron do
    set :rails_env, "production" unless exists?(:rails_env)
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} craken:install"
  end
end
