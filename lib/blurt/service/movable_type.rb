module Blurt
  module Service
    
    class MovableType

      include Interface
      
      def getCategoryList(blog_id)
        Tag.by_name.map {|t| to_struct(t) }
      end
      
      def getPostCategories(post_id)
        post = Post.find(post_id)
        post.tags.by_name.map do |tag|
          to_struct(tag).merge(:isPrimary => false)
        end
      end
      
      def setPostCategories(post_id, categories)
        post = Post.find(post_id)
        post.tag_names = categories
        post.save!
      end
      
      def publishPost(post_id)
        Post.find(post_id).touch
      end
      
      # TODO: this duplicates MetaWeblog#getRecentPosts
      def getRecentPostTitles(blog_id, limit)
        Post.by_date.with_limit(limit).map {|p| to_struct(p) }
      end
      
      private
      def tag_struct(tag)
        {
          :categoryId   => tag.id.to_s,
          :categoryName => tag.name
        }
      end
      
      def post_struct(post)
        {
          :postid      => post.id.to_s,
          :userid      => '1',
          :title       => post.title,
          :dateCreated => post.created_at
        }
      end
      
    end
  
  end
end