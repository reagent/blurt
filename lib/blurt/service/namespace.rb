module Blurt
  module Service
    class Namespace
      
      attr_reader :name
      
      def initialize(name)
        @name    = name
        @methods = MethodCollection.new(self)
        @structs = StructCollection.new
      end

      def methods
        @methods.names.map {|name| "#{self.name}.#{name}"}
      end
      
      def method(name, &block)
        @methods.add(name, &block)
      end
      
      def struct(type, &block)
        @structs.add(type, &block)
      end
      
      def call(method_name, *params)
        @methods.call(method_name, *params)
      end
      
      def to_struct(thing, type)
        @structs.transform(type, thing)
      end
      
    end
  end
end