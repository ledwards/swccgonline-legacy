# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

default_run_options[:pty] = true # fix for railsplayground's stupid sudoers file
set :use_sudo, false

set :user, 'terron'
set :server, 'swccgonline.com'
set :application, "swccgonline" 
set :repository, "https://secure2.svnrepository.com/s_terron/swccgonline/trunk"

set :scm_username, "terron"
set :scm_password, "solo4170"

ssh_options[:forward_agent] = true

role :web, 'swccgonline.com'
role :app, 'swccgonline.com'
role :db,  'swccgonline.com', :primary => true

# Set deployment location here
#set :deploy_to, "/home/#{user}/#{application}" 
set :deploy_to, "/home/#{user}/stagingareas"

set :group_writable, false

task :restart, :roles => :app do
end

before "deploy:start" do 
  run "ruby #{current_path}/script/ferret_server -e production start"
end 
 
after "deploy:stop" do 
  run "ruby #{current_path}/script/ferret_server -e production stop"
end
 
after 'deploy:restart' do
  run "cd #{current_path} && ruby ./script/ferret_server -e production stop"
  run "cd #{current_path} && ruby ./script/ferret_server -e production start"
end

task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end
