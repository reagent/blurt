require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt
  module Helpers
    
    class UrlHelperTest < ActiveSupport::TestCase
      
      include UrlHelper
      
      context "The UrlHelper module" do
        
        should "know the root url" do
          Blurt.stubs(:configuration).with().returns(stub(:url => 'http://localhost:4567'))
          
          assert_equal 'http://localhost:4567/', root_url
        end
        
        should "know the feed url" do
          self.stubs(:root_url).with().returns('http://localhost/')
          assert_equal 'http://localhost/feed', feed_url
        end
        
        should "know the sitemap url" do
          self.stubs(:root_url).with().returns('http://localhost/')
          assert_equal 'http://localhost/sitemap.xml', sitemap_url
        end
        
        should "know the tags url" do
          self.stubs(:root_url).with().returns('http://localhost/')
          assert_equal 'http://localhost/tags', tags_url
        end

        should "know the tag_url" do
          tag = stub(:slug => 'slug')
          self.stubs(:root_url).with().returns('http://localhost/')
          
          assert_equal 'http://localhost/tag/slug', tag_url(tag)
        end

        should "know the page_url" do
          self.stubs(:root_url).with().returns('http://localhost/')
          assert_equal 'http://localhost/page/1', page_url(1)
        end
        
        should "know the post url" do
          post = stub(:slug => 'slug')
          self.stubs(:root_url).with().returns('http://localhost/')
          
          assert_equal 'http://localhost/slug', post_url(post)
        end
        
      end
      
    end
    
  end
end