module Api
  class Service < ActionWebService::Base
  
    web_service_api Api::Definition
      
    def newPost(blogid, username, password, struct, publish)
      post = ::Post.create(:title => struct['title'], :body => struct['description'])
      post.id.to_s
    end
 
    def getPost(postid, username, password)
      Api::Struct::Post.from_active_record(Post.find(postid))
    end
    
    def editPost(post_id, username, password, struct, publish)
      Post.find(post_id).update_attributes(:title => struct['title'], :body => struct['description'])
      true
    end
  
  end
end