module Api
  class Service < ActionWebService::Base

    class UnauthenticatedError < StandardError; end
  
    web_service_api Api::Definition
    
    def newPost(blog_id, username, password, struct, publish)
      post = ::Post.create(
        :title     => struct['title'], 
        :body      => struct['description'], 
        :tag_names => struct['categories']
      )
      post.id.to_s
    end

    def getPost(post_id, username, password)
      Api::Struct::Post.from_active_record(Post.find(post_id))
    end
    
    def editPost(post_id, username, password, struct, publish)
      Post.find(post_id).update_attributes(
        :title     => struct['title'], 
        :body      => struct['description'],
        :tag_names => struct['categories']
      )
      true
    end
    
    def getRecentPosts(blog_id, username, password, limit)
      Post.by_date.with_limit(limit).map {|post| Api::Struct::Post.from_active_record(post) }
    end
    
    def getCategories(blog_id, username, password)
      Tag.by_name.map {|tag| Api::Struct::Tag.from_active_record(tag)}
    end
  
    def newMediaObject(blog_id, username, password, struct)
      media = ::Media.new(struct)
      media.save!
      
      media.to_struct
    end
  
    # Add authentication to API methods
    [:newPost, :getPost, :editPost, :getRecentPosts, :getCategories].each do |method_name|
      class_eval <<-EOM
        def #{method_name}_with_authentication(*params)
          authenticate!(params[1], params[2])
          #{method_name}_without_authentication(*params)
        end
      EOM
      
      alias_method_chain method_name, :authentication
    end
    
    private
    def authenticate!(username, password)
      authenticated   = (Blurt.configuration.username == username)
      authenticated &&= (Blurt.configuration.password == password)

      raise UnauthenticatedError, "Could not authenticate this user, please check your credentials" unless authenticated
    end
    
  end
end