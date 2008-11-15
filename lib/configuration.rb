module ConfigurationReader
  
  module ClassMethods
    def configuration_reader(*keys)
      keys.each do |key|
        define_method key do
          @configuration[key.to_s]
        end
      end
    end
  end
  
  module InstanceMethods
    def initialize(configuration)
      @configuration = configuration
    end
  end
  
end

class Configuration 

  def self.from_file(file)
    @configuration ||= YAML.load_file(file)
  end

  def self.application
    Application.new(@configuration['application'])
  end

  def self.authentication
    Authentication.new(@configuration['authentication'])
  end

  class Application

    extend ConfigurationReader::ClassMethods
    include ConfigurationReader::InstanceMethods
    
    configuration_reader :theme

    def base_url
      port_spec = ":#{@configuration['port']}" if (@configuration['port'] && @configuration['port'].to_s != '80')
      "http://#{@configuration['host']}#{port_spec}/"
    end

  end

  class Authentication

    extend ConfigurationReader::ClassMethods
    include ConfigurationReader::InstanceMethods

    configuration_reader :username, :password

  end

end

