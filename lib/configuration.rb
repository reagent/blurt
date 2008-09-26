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
    
    def initialize(configuration)
      @configuration = configuration
    end
    
    def base_url
      port_spec = ":#{@configuration['port']}" if (@configuration['port'] && @configuration['port'].to_s != '80')
      "http://#{@configuration['host']}#{port_spec}/"
    end
    
  end
  
  class Authentication
    
    def initialize(configuration)
      @configuration = configuration
    end
    
    def username
      @configuration['username']
    end
    
    def password
      @configuration['password']
    end
    
  end
  
end

