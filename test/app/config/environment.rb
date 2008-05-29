# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.991' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

DOT_RAILS_PATH = "../home"

#require "#{RAILS_ROOT}/vendor/plugins/dot_rails/lib/dot_rails"
require "../../lib/dot_rails"

Rails::Initializer.run do |config|
  config.plugin_paths = ["../../.."]  # the directory containing the dot_rails project
  config.plugins = [:dot_rails]  # load only our plugin, just in case there are other plugin projects at the same level

  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_app_session',
    :secret      => '5b7fb69d1e086cd9faa43d0f521f7b85dab9a3b7df7398600a06faacba274002cca932a14ac1ce58eeca1d5822e4205f047e231d662e1a374bdf436a0d1d5c36'
  }
  puts "env"
end