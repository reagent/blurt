module Blurt
  module Helpers
    
    module UrlHelper
      
      def root_url
        "#{Blurt.configuration.url}/"
      end
      
      def feed_url
        "#{root_url}feed"
      end
      
      def sitemap_url
        "#{root_url}sitemap.xml"
      end
      
      def tags_url
        "#{root_url}tags"
      end
      
      def tag_url(tag)
        "#{root_url}tag/#{tag.slug}"
      end
      
      def post_url(post)
        "#{root_url}#{post.slug}"
      end
      
      def page_url(page_number)
        "#{root_url}page/#{page_number}"
      end
      
    end
    
  end
end