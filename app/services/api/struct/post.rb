module Api
  module Struct
  
    class Post < ActionWebService::Struct
      member :postid,       :string
      member :title,        :string
      member :link,         :string
      member :description,  :string
    
      def self.from_active_record(post)
        self.new(
          :postid      => post.id.to_s,
          :title       => post.title,
          :link        => '',
          :description => post.body
        )
      end
    end
  
  end
end