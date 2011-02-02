set :application, "Versionize"
set :repository,  "git@github.com:runemadsen/Versionize.git"

set :deploy_to, "home/rune/public_html/versionize.com"
set :user, "rune"
set :branch, "release"
#set :use_sudo, false
set :use_sudo, true

set :scm, :git

role :web, "184.106.217.110:30000"
role :app, "184.106.217.110:30000"
role :db, "184.106.217.110:30000", :primary => true

# Passenger stuff
namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
 run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end