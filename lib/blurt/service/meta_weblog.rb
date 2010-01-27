module Blurt
  module Service
    
    class MetaWeblog
      
      include Service
      
      def newPost(blog_id, struct, publish_flag)
        post = Post.create!(
          :title     => struct['title'],
          :body      => struct['description'],
          :tag_names => struct['categories']
        )
        post.id.to_s
      end
    
      def getPost(id)
        to_struct(Post.find(id))
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
        Post.by_date.with_limit(limit).map {|p| to_struct(p) }
      end
    
      def getCategories(blog_id)
        Tag.by_name.map {|t| to_struct(t) }
      end
    
      def newMediaObject(blog_id, struct)
        media = Media.new(struct)
        media.save!
      
        media.to_struct
      end
      
      private
      def post_struct(post)
        {
          :postid      => post.id.to_s,
          :title       => post.title,
          :categories  => post.tag_names,
          :permaLink   => post.permalink,
          :description => post.body,
          :dateCreated => post.created_at
        }
      end
      
      def tag_struct(tag)
        {
          :description => tag.name,
          :htmlUrl     => '',
          :rssUrl      => ''
        }
      end
      
    end
    
  end
end