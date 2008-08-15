# Runs craken:install on all the app servers.
namespace :craken do
  desc "Install raketab"
  task :install, :roles => :cron do
    set :rails_env, "production" unless exists?(:rails_env)
    set :env_args, env_args || "app_name=#{application} deploy_path=#{current_path}"
    run "cd #{current_path} && rake #{env_args} RAILS_ENV=#{rails_env} craken:install"
  end
end
