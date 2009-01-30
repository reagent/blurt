require File.dirname(__FILE__) + '/../test_helper'

class SitemapTest < ActiveSupport::TestCase
  
  context "An instance of the Sitemap class" do
    
    setup { @sitemap = Sitemap.new }
    
    should "have a :root element" do
      @sitemap.expects(:root_url).with().returns('root_url')
      ::Post.expects(:maximum).with(:updated_at).returns('max')
      
      root = stub()
      
      Sitemap::Element.expects(:new).with(:location => 'root_url', :modified_at => 'max').returns(root)
      
      assert_equal root, @sitemap.root
    end
    
    should "have a collection of posts" do
      sm_post = stub()
      post    = stub()
      
      ::Post.expects(:by_date).with().returns([post])
      
      Sitemap::Post.expects(:new).with(post).returns(sm_post)
      
      assert_equal [sm_post], @sitemap.posts
    end
    
    should "have a collection of pages" do
      page_2 = stub()
      
      ::Post.expects(:page_count).with().returns(2)
      
      Sitemap::Page.expects(:new).with(2).returns(page_2)
      
      assert_equal [page_2], @sitemap.pages
    end
    
    should "have a :tag_list element" do
      element = stub()
      time = Time.parse('2009-08-01 00:00:00')
      
      Tag.expects(:maximum).with(:updated_at).returns(time)
      @sitemap.expects(:tags_url).with().returns('tags_url')
      
      Sitemap::Element.expects(:new).with(:location => 'tags_url', :modified_at => time).returns(element)
      
      assert_equal element, @sitemap.tag_list
    end
    
    should "have a collection of tags" do
      tag = stub()
      sm_tag = stub()
      
      ::Tag.expects(:all).with().returns([tag])
      Sitemap::Tag.expects(:new).with(tag).returns(sm_tag)
      
      assert_equal [sm_tag], @sitemap.tags
    end
    
    should "have a way to build XML" do
      builder = stub()
      Builder::XmlMarkup.expects(:new).with(:indent => 2).returns(builder)
      
      assert_equal builder, @sitemap.xml
    end    
    
  end
  
  context "An instance of the Sitemap::Element class" do
    setup { @element = Sitemap::Element.new }
    
    should "have a :location" do
      e = Sitemap::Element.new(:location => 'location')
      assert_equal 'location', e.location
    end
    
    should "have a value for :modified_on" do
      time = Time.parse('2009-08-01 00:00:00')
      
      e = Sitemap::Element.new(:modified_at => time)
      assert_equal '2009-08-01', e.modified_on
    end
    
    should "return today's date if :modified_at is nil" do
      time = Time.parse('2009-08-01 00:00:00')
      Time.expects(:now).at_least_once.with().returns(time)
      
      assert_equal '2009-08-01', @element.modified_on
    end
    
    should "have a default value for :change_frequency" do
      assert_equal 'daily', @element.change_frequency
    end
    
    should "have a default value for priority" do
      assert_equal '0.8', @element.priority
    end
    
    should "have a way to build XML" do
      builder = stub()
      Builder::XmlMarkup.expects(:new).with(:indent => 2, :margin => 1).returns(builder)
      
      assert_equal builder, @element.xml
    end
    
    context "when generating xml" do
      setup do
        @location    = 'location'
        @modified_at = Time.now

        @element = Sitemap::Element.new(:location => @location, :modified_at => @modified_at)

        @expected_xml =
          "  <url>\n" +
          "    <loc>#{@location}</loc>\n" +
          "    <lastmod>#{@modified_at.strftime('%Y-%m-%d')}</lastmod>\n" +
          "    <changefreq>daily</changefreq>\n" +
          "    <priority>0.8</priority>\n" +
          "  </url>\n"
      end        
    
      should "be able to generate xml" do
        assert_equal @expected_xml, @element.to_xml
      end
      
      should "not generate duplicate xml" do
        @element.to_xml
        assert_equal @expected_xml, @element.to_xml
      end
      
    end
  end
  
  context "An instance of the Sitemap::Post class" do
    should "determine the location and modified_at from a post object" do
      post = Factory(:post)
      
      sm_post = Sitemap::Post.new(post)
      
      assert_equal post.permalink, sm_post.location
      assert_equal post.updated_at.strftime('%Y-%m-%d'), sm_post.modified_on
    end
    
    should "have a monthly :change_frequency" do
      tag = Sitemap::Post.new(Factory(:post))
      assert_equal 'monthly', tag.change_frequency
    end
    
    should "have a value for priority" do
      tag = Sitemap::Post.new(Factory(:post))
      assert_equal '0.5', tag.priority
    end
  end
  
  context "An instance of the Sitemap::Page class" do
    should "determine the location and modified_at from a page number and post data" do
      ::Post.expects(:maximum).with(:updated_at).returns(Time.parse('2009-08-01 00:00:00'))
      Sitemap::Page.any_instance.expects(:posts_url).with(1).returns('posts_url')
      
      page = Sitemap::Page.new(1)
      
      assert_equal 'posts_url', page.location
      assert_equal '2009-08-01', page.modified_on
    end
  end
  
  context "An instance of the Sitemap::Tag class" do
    should "determine the location and modified_at from a tag object" do
      tag = Factory(:tag)
      
      Sitemap::Tag.any_instance.expects(:tag_url).with(tag).returns('tag_url')
      sm_tag = Sitemap::Tag.new(tag)
      
      assert_equal 'tag_url', sm_tag.location
      assert_equal tag.updated_at.strftime('%Y-%m-%d'), sm_tag.modified_on
    end
    
    should "have a monthly :change_frequency" do
      tag = Sitemap::Tag.new(Factory(:tag))
      assert_equal 'monthly', tag.change_frequency
    end
    
    should "have a value for priority" do
      tag = Sitemap::Tag.new(Factory(:tag))
      assert_equal '0.5', tag.priority
    end
  end
  
end
