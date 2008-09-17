class Authenticator
  
  def self.configuration_file
    "#{RAILS_ROOT}/config/sneaq.yml"
  end
  
  def self.configuration
    YAML.load_file(self.configuration_file) if File.exist?(self.configuration_file)
  end
  
  def self.authenticated?(username, password)
    authenticated = !self.configuration.nil?
    authenticated = authenticated && [self.configuration['username'], self.configuration['password']] == [username, password]
    authenticated
  end
  
  def self.with_authentication(username, password, &block)
    block.call if self.authenticated?(username, password)
  end
  
end