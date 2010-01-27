module Blurt
  
  class RequestHandler
    
    def initialize(raw_request)
      @raw_request = raw_request
    end
    
    def to_struct
      @struct ||= XMLRPC::Marshal.load_call(@raw_request)
    end
    
    def service_class
      case service_name
      when 'metaWeblog' then Blurt::Service::MetaWeblog
      when 'mt'         then Blurt::Service::MovableType
      end
    end
    
    def service_name
      to_struct[0].sub(/\..+$/, '')
    end
    
    def method_name
      to_struct[0].sub(/^[^\.]+\./, '')
    end
    
    def parameters
      to_struct[1]
    end
    
    def response
      service = service_class.new(method_name, *parameters)
      XMLRPC::Marshal.dump_response(service.call)
    end
    
  end
  
end