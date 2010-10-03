module Blurt
  
  class RequestHandler
    
    def initialize(raw_request)
      @raw_request = raw_request
    end
    
    def to_struct
      @struct ||= XMLRPC::Marshal.load_call(@raw_request)
    end
    
    def method_name
      to_struct[0]
    end
    
    def parameters
      @parameters ||= to_struct[1]
    end
    
    def response
      raw_response = Blurt::Service.call(method_name, *parameters)
      XMLRPC::Marshal.dump_response(raw_response)
    end
    
  end
  
end