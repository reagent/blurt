module Blurt
  module Service
    
    class MethodCollection

      attr_reader :methods

      def initialize(namespace)
        @namespace = namespace
        @methods   = {}
      end
      
      def names
        @methods.keys.sort
      end
      
      def add(method_name, &block)
        @methods[method_name.to_s] = block
      end
      
      def to_struct(type, thing)
        @namespace.to_struct(type, thing)
      end
      
      def authenticate(username, password)
        Blurt::Service.authenticate(username, password)
      end

      # TODO: Handle the case where method is not found:
      #   undefined method `arity' for nil:NilClass (NoMethodError)
      #   ./lib/blurt/service/method_collection.rb:25:in `call'
      def call(method_name, *params)
        method         = @methods[method_name.to_s]
        expected_arity = (method.arity > 0) ? method.arity : 0
        actual_arity   = params.length

        if actual_arity != expected_arity
          message = "Calling method #{method_name}: Wrong number of parameters - expected #{expected_arity}, got #{actual_arity}"
          raise ArgumentError, message
        end
        
        instance_exec(*params, &method)
      end
      
    end
    
  end
end