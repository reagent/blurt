module Blurt
  
  class RequestHandler
    
    def initialize(raw_request)
      @raw_request = raw_request
    end
    
    def to_struct
      @struct ||= XMLRPC::Marshal.load_call(@raw_request)
    end
    
    def method_name
      to_struct[0].sub(/^metaWeblog\./, '')
    end
    
    def parameters
      to_struct[1]
    end
    
    def response
      service = Service.new(method_name, *parameters)
      XMLRPC::Marshal.dump_response(service.call)
    end
    
  end
  
end