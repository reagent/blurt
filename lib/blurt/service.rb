module Blurt
  class Service

    class AuthenticationError < StandardError; end
    
    def initialize(method_name, *parameters)
      @method_name = method_name
      @parameters  = parameters
    end
    
    def username
      @parameters[1]
    end
    
    def password
      @parameters[2]
    end
    
    def newPost
      struct = @parameters[3]
      
      post = Post.create!(
        :title     => struct['title'],
        :body      => struct['description'],
        :tag_names => struct['categories']
      )
      post.id.to_s
    end
    
    def getPost
      id = @parameters[0]
      Post.find(id).to_struct
    end
    
    def editPost
      id     = @parameters[0]
      struct = @parameters[3]
      
      post = Post.find(id)
      post.update_attributes(
        :title     => struct['title'],
        :body      => struct['description'],
        :tag_names => struct['categories']
      )
    end
    
    def getRecentPosts
      limit = @parameters[3]
      Post.by_date.with_limit(limit).map {|p| p.to_struct }
    end
    
    def getCategories
      Tag.by_name.map {|t| t.to_struct }
    end
    
    def newMediaObject
      media_struct = @parameters[3]
      media = Media.new(media_struct)
      media.save!
      
      media.to_struct
    end
    
    def authenticate
      unless username == Blurt.configuration.username && password == Blurt.configuration.password
        raise AuthenticationError, "User #{username} failed to authenticate"
      end
    end
    
    def call
      authenticate
      self.send(@method_name)
    end
    
  end
end