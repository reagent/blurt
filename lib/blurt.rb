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
    configuration.prepare_public_directory!
  end
  
end