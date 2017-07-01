require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'ingress'
set :domain, 'ingress'
set :user, 'ingress'
set :deploy_to, '/srv/ingress'
set :repository, 'https://github.com/anarchocurious/ingress.git'
set :branch, 'master'

set :rvm_use_path, '/usr/local/rvm/scripts/rvm'

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push('tmp/pids', 'public/system')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/network_scan.yml', 'config/redis.yml', 'config/schedule.yml', 'config/secrets.yml', 'config/sidekiq.yml')

task :environment do
  invoke :'rvm:use', "#{File.read('.ruby-version').chomp}@#{File.read('.ruby-gemset').chomp}"
end

task :console => :environment do
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %{source #{fetch(:rvm_use_path)}}
  command %{rvm install #{File.read('.ruby-version').chomp}}
  command %{rvm use --create #{File.read('.ruby-version').chomp}@#{File.read('.ruby-gemset').chomp}}
  command %{gem install bundler}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    command %{rvm alias create ingress #{File.read('.ruby-version').chomp}@#{File.read('.ruby-gemset').chomp}}

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
        command %{systemctl --user restart sidekiq}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
