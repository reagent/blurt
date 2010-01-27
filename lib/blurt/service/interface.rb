module Blurt
  module Service
    module Interface

      module InstanceMethods
        
        attr_reader :parameters
        
        def initialize(method_name, *parameters)
          @method_name = method_name
          @parameters  = parameters
        end
    
        def extract_credentials
          @parameters.slice!(1, 2)
        end
    
        def authenticate
          username, password = extract_credentials
          
          unless username == Blurt.configuration.username && password == Blurt.configuration.password
            raise AuthenticationError, "User #{username} failed to authenticate"
          end
        end
        
        def authenticate?
          !self.class.public_entry_points.include?(@method_name.to_sym)
        end
    
        def call
          authenticate if authenticate?
          send(@method_name, *parameters)
        end
    
        def to_struct(thing)
          case thing
          when Post then post_struct(thing)
          when Tag  then tag_struct(thing)
          end
        end
        
      end
      
      module ClassMethods

        def skip_authentication_for(*method_names)
          @public_entry_points = method_names
        end
        
        def public_entry_points
          @public_entry_points || []
        end

      end
      
      def self.included(klass)
        klass.send(:extend, ClassMethods)
        klass.send(:include, InstanceMethods)
      end
    
    end
  end
end