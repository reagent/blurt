require File.dirname(__FILE__) + '/../vendor/gems/environment'
Bundler.require_env ENV['RACK_ENV']

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'sinatra/base'
require 'blurt'

begin
  require 'config/setup'
rescue LoadError
  puts "Please create the file config/setup.rb (see the example file)"
  exit 1
end

require 'lib/blurt/application'