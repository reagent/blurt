module Api
  module Struct
  
    class Media < ActionWebService::Struct
      member :name, :string
      member :type, :string
      member :bits, :base64
      member :url,  :string
    end
    
  end
end