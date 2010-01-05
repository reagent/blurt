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