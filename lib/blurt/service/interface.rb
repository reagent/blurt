module Blurt
  module Service
    module Interface

      attr_reader :parameters
    
      def initialize(method_name, *parameters)
        @method_name = method_name
        @parameters  = parameters
      end
    
      def extract_credentials
        @parameters.slice!(1, 2)
      end
    
      def authenticate(username, password)
        unless username == Blurt.configuration.username && password == Blurt.configuration.password
          raise AuthenticationError, "User #{username} failed to authenticate"
        end
      end
    
      def call
        username, password = extract_credentials
        authenticate(username, password)
        send(@method_name, *parameters)
      end
    
      def to_struct(thing)
        case thing
        when Post then post_struct(thing)
        when Tag  then tag_struct(thing)
        end
      end
    
    end
  end
end