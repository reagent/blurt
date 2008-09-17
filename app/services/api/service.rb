module Api
  class Service < ActionWebService::Base
  
    web_service_api Api::Definition
      
    def newPost(blogid, username, password, struct, publish)
      Authenticator.with_authentication(username, password) do
        post = ::Post.create(:title => struct['title'], :body => struct['description'])
        post.id.to_s
      end
    end
 
    def getPost(postid, username, password)
      Authenticator.with_authentication(username, password) do
        Api::Struct::Post.from_active_record(Post.find(postid))
      end
    end
    
    def editPost(post_id, username, password, struct, publish)
      Authenticator.with_authentication(username, password) do
        Post.find(post_id).update_attributes(:title => struct['title'], :body => struct['description'])
        true
      end
    end
    
    def getRecentPosts(blog_id, username, password, limit)
      Authenticator.with_authentication(username, password) do
        Post.by_date.with_limit(limit).map {|post| Api::Struct::Post.from_active_record(post) }
      end
    end
  
  end
end