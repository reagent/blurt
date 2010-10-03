require 'blurt/service/namespace'
require 'blurt/service/method_collection'
require 'blurt/service/struct_collection'

module Blurt
  module Service

    class AuthenticationError < Exception; end
    
    def self.namespaces
      @namespaces ||= {}
    end
    
    def self.methods
      namespaces.values.map {|namespace| namespace.methods }.flatten
    end
    
    def self.current_namespace
      @current_namespace
    end
    
    def self.load(definition)
      instance_eval(definition)
    end
    
    def self.load_file(file)
      load(File.read(file))
    end
    
    def self.authentication(&block)
      @authentication_method = block
    end
    
    def self.authenticate(username, password)
      success = @authentication_method.call(username, password)
      raise AuthenticationError, "Could not authenticate user" unless (success === true)
    end
    
    def self.service(name, &block)
      namespace =  Namespace.new(name)
      
      self.namespaces[name] = namespace
      @current_namespace    = namespace
      
      instance_eval(&block)
    end
    
    def self.method(method_name, &block)
      current_namespace.method(method_name, &block)
    end
    
    def self.struct(type, &block)
      current_namespace.struct(type, &block)
    end
    
    def self.call(namespaced_method_name, *params)
      namespace, method_name = namespaced_method_name.split('.')
      result = namespaces[namespace.to_sym].call(method_name, *params)
    end
    
  end
end