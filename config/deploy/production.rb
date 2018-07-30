# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:


server "95.213.195.18", user: 'deployer', roles: %w{app db web}, primary: true


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.


role :app, %w{deployer@95.213.195.18}
role :web, %w{deployer@95.213.195.18}
role :db,  %w{deployer@95.213.195.18}

set :rails_env, "production"
set :stage, :production

set :sidekiq_config, -> { File.join(current_path, ‘config’, ‘sidekiq.yml’) }
# Configuration
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
set :ssh_options, {
    keys: %w(/home/tux/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 4321
}
