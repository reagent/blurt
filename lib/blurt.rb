require File.dirname(__FILE__) + '/../vendor/gems/environment'
Bundler.require_env

require 'xmlrpc/marshal'

require 'lib/core_ext'
require 'lib/title'
require 'lib/sluggable'

require 'lib/blurt/formatter'
require 'lib/blurt/request_handler'
require 'lib/blurt/service'
require 'lib/blurt/configuration'
require 'lib/blurt/theme'
require 'lib/blurt/helpers'

require 'lib/models'

module Blurt
  
  def self.root
    relative_path = File.dirname(__FILE__) + '/..'
    Pathname.new(File.expand_path(relative_path))
  end
  
  def self.configuration
    @configuration ||= Blurt::Configuration.new(Blurt.root)
  end
  
  def self.setup(&block)
    configuration = self.configuration
    yield configuration
    configuration.boot
  end
  
  def self.view_path
    configuration.theme.view_path
  end
  
  def self.asset_path
    configuration.theme.asset_path
  end
  
end