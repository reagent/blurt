require File.dirname(__FILE__) + '/../vendor/gems/environment'
Bundler.require_env ENV['RACK_ENV']

require 'sinatra/base'
require 'lib/blurt'

begin
  require 'config/setup'
rescue LoadError
  puts "Please create the file config/setup.rb (see the example file)"
  exit 1
end

require 'lib/blurt/application'