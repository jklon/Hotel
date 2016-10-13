# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'Hotel'
set :repo_url, 'git@github.com:jklon/Hotel.git'
set :rbenv_ruby, '2.1.2'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :ssh_options, {:keys => %w(~/.ssh/aws-ashoka.pem)}
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        #execute :bundle, "exec rake assets:precompile"
        execute :bundle, "exec thin restart -C config/thin/production.yml -o 0"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
after 'deploy:publishing', 'thin:restart'
after "bundle:install" do
  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
end
