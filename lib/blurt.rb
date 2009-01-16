module Blurt
  
  def self.configuration
    @configuration ||= Blurt::Configuration.new(Rails.root)
  end
  
  def self.setup(&block)
    yield self.configuration
  end
  
end