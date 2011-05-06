set :application, "abredatos2011"
set :repository,  "git@github.com:guillermo/abredatos2011.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "epifanio.cientifico.net"                          # Your HTTP server, Apache/etc
role :app, "epifanio.cientifico.net"                          # This may be the same as your `Web` server
role :db,  "epifanio.cientifico.net", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :use_sudo, false
set :deploy_to, '/var/www/apps/abredatos2011'
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end


require 'bundler/capistrano'


# Update database.yml
namespace :config do
  desc "Update database.yml"
  task :database, :role => :app do
    run "rm #{release_path}/config/database.yml ; echo Borrado "
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'config:database'

