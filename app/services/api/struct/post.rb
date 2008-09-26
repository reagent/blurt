module Api
  module Struct
  
    class Post < ActionWebService::Struct
      member :postid,       :string
      member :title,        :string
      member :categories,   [:string]
      member :permaLink,    :string
      member :description,  :string
      member :dateCreated,  :time
    
      def self.from_active_record(post)
        self.new(
          :postid      => post.id.to_s,
          :title       => post.title,
          :categories  => post.tag_names,
          :permaLink   => post.permalink,
          :description => post.content.to_s,
          :dateCreated => post.created_at
        )
      end
    end
  
  end
end