module Blurt
  
  def self.configuration
    @configuration ||= Blurt::Configuration.new(Rails.root)
  end
  
  def self.setup(&block)
    configuration = self.configuration
    yield configuration
    configuration.prepare_public_directory!
  end
  
end