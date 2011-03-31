set :application, "Versionize"
set :repository,  "git@github.com:runemadsen/Versionize.git"

set :port, 30000
set :deploy_to, "/home/rune/public_html/versionize.com"
set :user, "rune"
set :branch, "release"
set :use_sudo, false
#set :use_sudo, true
set :deploy_via, :remote_cache

set :scm_verbose, true

# These solve errors, look here: http://weblog.rubyonrails.org/2007/10/14/capistrano-2-1
default_run_options[:pty] = true
default_run_options[:shell] = false

set :scm, :git

role :web, "50.56.76.236"
role :app, "50.56.76.236"
role :db, "50.56.76.236", :primary => true

# Passenger and symlink stuff
namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
 run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
 task :symlink, :roles => :app do
   run <<-CMD
     ln -nfs #{shared_path}/system/repos #{release_path}/repos
   CMD
 end
end

