## Generated with 'brightbox-capify' on 2014-01-20 09:29:40 +0100
gem 'brightbox', '>=2.4.6'
require 'brightbox/recipes'
require 'brightbox/passenger'

# The name of your application.  Used for deployment directory and filenames
# and Apache configs. Should be unique on the Brightbox
set :application, "krubyrails6cs"

# Primary domain name of your application. Used in the Apache configs
set :domain, "www.kruby.dk"

set :domain_aliases, "krubyrails6cs.public.srv-ve6sn.gb1.brightbox.com,kruby.dk,www.applemac.dk,applemac.dk,mortenmadsen.dk,www.mortenmadsen.dk"

## List of servers
server "cip-k7yto.gb1.brightbox.com", :app, :web, :db, :primary => true

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", user, application) }

# URL of your source repository. By default this will just upload
# the local directory.  You should probably change this if you use
# another repository, like git or subversion.

set :repository, "git@github.com:kruby/kruby_rails_6_cs.git"
set :scm, :git
set :deploy_via, :copy
set :branch, "master"

set :user, "ubuntu"

## Deployment settings
# The brightbox gem deploys as the user 'rails' by default and
# into the 'production' environment. You can change these as required.
# set :rails_env, :production

# namespace :deploy do
#  namespace :rake_tasks do
#    task :singleton, :roles => :db, :only => {:primary => true} do
#      run rake_task("db:create")
#      run rake_task("migrate_old_data_production")
#      #HUSK at denne rake task ligger i lib/tasks og filen hedder kruby_data_migrate_production.rake
#      #Den tilsvarende til development skal omdøbes til .xrake for ikke at ligge i vejen når du deploy'er
#    end
#  end
# end

### Other options you can set ###
# Comma separated list of additional domains for Apache
# set :domain_aliases, "www.example.com,dev.example.com"

## Dependencies
# Set the commands and gems that your application requires. e.g.
# depend :remote, :gem, "will_paginate", ">=2.2.2"
# depend :remote, :command, "brightbox"
#
# If you're using Bundler, then you don't need to specify your
# gems here as well as there (and the bundler gem is installed for
# you automatically). If you're not using bundler, uncomment the
# following line to explicitly disable it
# set :bundle_disable, true
# 
# Gem with a source (such as github)
# depend :remote, :gem, "tmm1-amqp", ">=0.6.0", :source => "http://gems.github.com"
# 
# Specify your specific Rails version if it is not vendored
# depend :remote, :gem, "rails", "=2.2.2"
#
# Set the apt packages your application or gems require. e.g.
# depend :remote, :apt, "libxml2-dev"

## Local Shared Area
# These are the list of files and directories that you want
# to share between the releases of your application on a particular
# server. It uses the same shared area as the log files.
#
# NOTE: local areas trump global areas, allowing you to have some
# servers using local assets if required.
#
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :local_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :local_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
# set :local_shared_dirs, %w(public/upload)
# set :local_shared_files, %w(config/database.yml)

load 'deploy/assets'

## Global Shared Area
# These are the list of files and directories that you want
# to share between all releases of your application across all servers.
# For it to work you need a directory on a network file server shared
# between all your servers. Specify the path to the root of that area
# in :global_shared_path. Defaults to the same value as :shared_path.
# set :global_shared_path, "/srv/share/myapp"
#
# NOTE: local areas trump global areas, allowing you to have some
# servers using local assets if required.
#
# Beyond that it is the same as the local shared area.
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :global_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :global_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
# set :global_shared_dirs, %w(public/upload)
# set :global_shared_files, %w(config/database.yml)

# SSL Certificates. If you specify an SSL certificate name then
# the gem will create an 'https' configuration for this application
# TODO: Upload and install the keys on the server
# set :ssl_certificate, "/path/to/certificate/for/my_app.crt"
# set :ssl_key, "/path/to/key/for/my_app.key
# or
# set :ssl_certificate, "name_of_installed_certificate"

## Static asset caching.
# By default static assets served directly by the web server are
# cached by the client web browser for 10 years, and cache invalidation
# of static assets is handled by the Rails helpers using asset
# timestamping.
# You may need to adjust this value if you have hard coded static
# assets, or other special cache requirements. The value is in seconds.
# set :max_age, 315360000

# SSH options. The forward agent option is used so that loopback logins
# with keys work properly
#ssh_options[:forward_agent] = true

# Forces a Pty so that svn+ssh repository access will work. You
# don't need this if you are using a different SCM system. Note that
# ptys stop shell startup scripts from running.
default_run_options[:pty] = true


#set :mongrel_port, 9600


## Logrotation
# Where the logs are stored. Defaults to <shared_path>/log
# set :log_dir, "central/log/path"
# The size at which to rotate a log. e.g 1G, 100M, 5M. Defaults to 100M
# set :log_max_size, "100M"
# How many old compressed logs to keep. Defaults to 10
# set :log_keep, "10"

## Version Control System
# Which version control system. Defaults to subversion if there is
# no 'set :scm' command.
# set :scm, :git
# set :scm_username, "rails"
# set :scm_password, "mysecret"
# or be explicit
# set :scm, :subversion



## Command running settings
# use_sudo is switched off by default so that commands are run
# directly as 'user' by the run command. If you switch on sudo
# make sure you set the :runner variable - which is the user the
# capistrano default tasks use to execute commands.
# NOTE: This just affects the default recipes unless you use the
# 'try_sudo' command to run your commands. The 'try_sudo' command
# has been deprecated in favour of 'run "#{sudo} <command>"' syntax.
# set :use_sudo, false
# set :runner, user## Passenger Configuration
# Set the method of restarting passenger
# :soft is the default and just touches tmp/restart.txt as normal.
# :hard forcibly kills running instances, rarely needed now but used
# to be necessary with older versions of passenger
# set :passenger_restart_strategy, :soft