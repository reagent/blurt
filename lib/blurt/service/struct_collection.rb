module Blurt
  module Service
    
    class StructCollection
      
      def initialize
        @definitions = {}
      end
      
      def add(type, &block)
        if block.arity != 1
          raise ArgumentError, "Defining struct for :#{type}: Wrong number of parameters - expecting 1"
        end
        
        @definitions[type] = block
      end
      
      def transform(thing, type)
        method = @definitions[type]
        method.call(thing)
      end
      
    end
    
  end
end