module Blurt
  class Service

    class AuthenticationError < StandardError; end
    
    attr_reader :parameters
    
    def initialize(method_name, *parameters)
      @method_name = method_name
      @parameters  = parameters
    end
    
    def extract_credentials
      @parameters.slice!(1, 2)
    end
    
    def newPost(blog_id, struct, publish_flag)
      post = Post.create!(
        :title     => struct['title'],
        :body      => struct['description'],
        :tag_names => struct['categories']
      )
      post.id.to_s
    end
    
    def getPost(id)
      Post.find(id).to_struct
    end
    
    def editPost(id, struct, publish_flag)
      post = Post.find(id)
      post.update_attributes(
        :title     => struct['title'],
        :body      => struct['description'],
        :tag_names => struct['categories']
      )
    end
    
    def getRecentPosts(blog_id, limit)
      Post.by_date.with_limit(limit).map {|p| p.to_struct }
    end
    
    def getCategories(blog_id)
      Tag.by_name.map {|t| t.to_struct }
    end
    
    def newMediaObject(blog_id, struct)
      media = Media.new(struct)
      media.save!
      
      media.to_struct
    end
    
    def authenticate(username, password)
      unless username == Blurt.configuration.username && password == Blurt.configuration.password
        raise AuthenticationError, "User #{username} failed to authenticate"
      end
    end
    
    def call
      username, password = extract_credentials
      authenticate(username, password)
      send(@method_name, *parameters)
    end
    
  end
end