module Blurt
  module Helpers
    
    module UrlHelper
      
      def root_url
        "#{Blurt.configuration.url}/"
      end
      
      def feed_url
        url_for('feed')
      end
      
      def sitemap_url
        url_for('sitemap.xml')
      end
      
      def tags_url
        url_for('tags')
      end
      
      def tag_url(tag)
        url_for("tag/#{tag.slug}")
      end
      
      def post_url(post)
        url_for(post.slug)
      end
      
      def page_url(page_number)
        url_for("page/#{page_number}")
      end
      
      private
      def url_for(path)
        root_url + path
      end
      
    end
    
  end
end