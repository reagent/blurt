class Authenticator
  
  def self.authenticated?(username, password)
    authenticated   = Configuration.authentication.username == username
    authenticated &&= Configuration.authentication.password == password
    authenticated
  end
  
  def self.with_authentication(username, password, &block)
    block.call if self.authenticated?(username, password)
  end
  
end