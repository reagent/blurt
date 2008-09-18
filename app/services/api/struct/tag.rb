module Api
  module Struct
  
    class Tag < ActionWebService::Struct
      member :description, :string
      member :htmlUrl, :string
      member :rssUrl, :string
      
      def self.from_active_record(tag)
        self.new(
          :description  => tag.name,
          :htmlUrl      => '',
          :rssUrl       => ''
        )
      end
      
    end
    
  end
end
