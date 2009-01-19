require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  should_require_attributes :title, :body
  
  should_have_many :taggings
  should_have_many :tags
  
  context "The Post class" do
    
    should "know how many posts to show on a page" do
      Blurt.stubs(:configuration).returns(mock(:per_page => 10))
      assert_equal 10, Post.per_page
    end
    
    should "return 1 as the default page count" do
      assert_equal 1, Post.page_count
    end
    
    should "know the page count when there is more than 1 page" do
      Post.stubs(:per_page).returns(5)
      Post.stubs(:count).returns(6)
      
      assert_equal 2, Post.page_count
    end
    
    should "know the page count when the record count falls exactly on the page threshold" do
      Post.stubs(:per_page).returns(1)
      Post.stubs(:count).returns(2)
      
      assert_equal 2, Post.page_count
    end
    
    should "be able to pull posts by page" do
      PaginatedPost.expects(:new).with(:page => 1).returns([stub()])
      Post.for_page(1)
    end
    
    should "default the page to 1 when pulling posts by page" do
      PaginatedPost.expects(:new).with(:page => 1)
      Post.for_page(nil)
    end
    
  end
  
  context "An instance of the Post class" do
    
    setup { @post = Post.new }
    
    should "have formattable content" do
      body = 'test'
      formatter = stub()
      
      @post.body = body
      Formatter::Code.stubs(:new).with(body).returns(formatter)
      
      assert_equal formatter, @post.content
    end
    
    should "have a list of assigned tag names" do
      tag_names = ['tag']
      @post.tag_names = tag_names
      assert_equal tag_names, @post.tag_names
    end
    
    should "default the list of tag names to an empty array" do
      assert_equal [], @post.tag_names
    end

    should "filter out duplicate tag names" do
      @post.tag_names = ['tag', 'tag']
      assert_equal ['tag'], @post.tag_names
    end
    
    should "pull the list of associated tags when available" do
      tag = Factory(:tag)
      @post.tags << tag
      
      assert_equal [tag.name], @post.tag_names
    end
    
    should "generate a slug before the post is validated" do
      @post.expects(:generate_slug)
      @post.valid?
    end
    
    should "expose the slug as the URL parameter" do
      @post.stubs(:slug).returns('foo')
      assert_equal 'foo', @post.to_param
    end
    
    should "be able to generate its own permalink" do
      @post.expects(:permalink_url).with(@post).returns('permalink')
      assert_equal 'permalink', @post.permalink
    end
    
    context "with a list of assigned tag names" do
      
      should "be able to create the associated tags" do
        @post = Factory(:post)
        
        tag_name = 'tag'
        @post.tag_names = [tag_name]

        @post.send(:save_tags)        
        assert_equal tag_name, @post.tags.first.name
      end
      
      should "reuse an existing tag when saving tags" do
        existing_tag = Factory(:tag)
        post = Factory(:post)
        
        post.tag_names = [existing_tag.name]
        post.send(:save_tags)
        
        assert_equal existing_tag, post.tags.first
      end
      
      should "save only the new tags" do
        post = Factory(:post)
        tag  = Factory(:tag, :name => 'original')
        post.tags << tag
        
        post.tag_names = ['new']
        post.send(:save_tags)
        
        assert_equal ['new'], post.tags.map(&:name)
      end
      
      should "save tags after saving the base record" do
        post = Factory(:post)
        post.expects(:save_tags).with()
        post.save
      end
      
    end
    
    context "with associated tags" do
      
      setup do
        @post = Factory(:post) 
        @tag = Factory(:tag)
        @post.tags << @tag
        
        @post = Post.find(@post.id)
      end
      
      should "not clear out the tag list when saving" do
        @post.save
        assert_equal [@tag], @post.tags
      end
      
    end
    
  end
  
end
