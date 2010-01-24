ENV['RACK_ENV'] = 'test'

require 'rubygems'
$:.unshift '../..'

require 'config/boot'
require 'test/unit/assertions'

require 'cucumber'
require 'capybara/cucumber'

require File.dirname(__FILE__) + '/helper'

require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation
  
require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_helper')

World(Test::Unit::Assertions, Helper)

Capybara.app = Blurt::Application