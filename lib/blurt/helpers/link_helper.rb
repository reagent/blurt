module Blurt
  module Helpers

    module LinkHelper
      
      include UrlHelper
      include Rack::Utils

      def link_to(content, url, html_options = {})
        options = html_options.map {|k, v| "#{k}=\"#{v}\"" }.join(' ')
        options = (options.strip == '') ? '' : " #{options}"
        
        "<a href=\"#{url}\"#{options}>#{h(content)}</a>"
      end
      
      def tag_links_for(post, html_options = {})
        post.tags.map {|tag| link_to tag.name, tag_url(tag), html_options }.join(', ')
      end

      def link_to_next_page(paginated_post)
        link_to('Next Page >>', page_url(paginated_post.next_page)) if paginated_post.next_page?
      end

      def link_to_previous_page(paginated_post)
        link_to('<< Previous Page', page_url(paginated_post.previous_page)) if paginated_post.previous_page?
      end
   
      alias_method :h, :escape_html
      
    end

  end
end