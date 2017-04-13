# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

  server "irisdev.corp.ooma.com", user: "iris", roles: %w{app db web}, primary: true
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

 # role :app ,%W{root@irisdev.corp.ooma.com}
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}
role :app, "irisdev.corp.ooma.com"

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    	 
       execute "cd #{ current_path }/shared/config/database.yml #{ current_path }/config/database.yml"

       execute "cd #{ current_path } && source ~/.rvm/scripts/rvm && rvm use 2.3.1 && rvm gemset use global && bundle install"
       
    	 execute "cd #{ current_path } && source ~/.rvm/scripts/rvm && rvm use 2.3.1 && rvm gemset use global && rake db:drop && rake db:create && rake db:migrate"
       
       execute "cd #{ current_path } && source ~/.rvm/scripts/rvm && rvm use 2.3.1 && rvm gemset use global && puma stop && puma start"
      
    	
 
    end
end
end

 
  
after "deploy", "deploy:restart" # Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }


