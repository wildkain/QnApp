# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "QnApp"
set :repo_url, "git@github.com:wildkain/QnApp.git"


# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qnapp"

# Default value for :format is :airbrussh.
 set :format, :airbrussh
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
 set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
# Deploy user name
 set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', '.env', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

namespace :deploy do
  desc "Reatart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
       #execute :touch, release_path.join('/tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

