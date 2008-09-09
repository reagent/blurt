module Api
  module Struct
  
    class Post < ActionWebService::Struct
      member :title,        :string
      member :link,         :string
      member :description,  :string
    
      def self.from_active_record(post)
        self.new(
          :title       => post.title,
          :link        => '',
          :description => post.body
        )
      end
    end
  
  end
end