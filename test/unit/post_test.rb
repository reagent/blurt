require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  should_require_attributes :title, :body
  
  should_have_many :taggings
  should_have_many :tags
  
  context "The Post class" do
    
    should "find other instances by their slugs" do
      post = Factory(:post)
      assert_equal post, Post.others_by_slug(nil, post.slug)
    end
    
    should "not find themselves if looking for others by slug" do
      post = Factory(:post)
      assert_nil Post.others_by_slug(post.id, post.slug)
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
    
    should "be able to produce a string representation of its tag list" do
      tag_one = Factory(:tag, :name => 'one')
      tag_two = Factory(:tag, :name => 'two')
      
      post = Factory(:post)
      post.tags << tag_one
      post.tags << tag_two
      
      assert_equal 'one, two', post.tags.to_s
    end
    
    should "know the next available slug when the original is taken" do
      Factory(:post, :title => 'Title')
      assert_equal 'title-2', @post.send(:next_available_slug, 'title')
    end
    
    should "incrementally suggest slugs until it finds an available one" do
      Factory(:post, :title => 'Title')
      Factory(:post, :title => 'Title')
      
      assert_equal 'title-3', @post.send(:next_available_slug, 'title')
    end
    
    should "know not to suggest an incremental slug when the existing slug belongs to the current record" do
      post = Factory(:post, :title => 'Title')
      assert_equal 'title', post.send(:next_available_slug, 'title')
    end
    
    should "not attempt to find the next slug if the initial slug is nil" do
      assert_nil @post.send(:next_available_slug, nil)
    end
    
    should "know how to generate a slug" do
      @post.title = 'My Title'
      @post.title.expects(:sluggify).with().returns('my-title')
      @post.expects(:next_available_slug).with('my-title').returns('my-title')
      
      @post.send(:generate_slug)
      assert_equal 'my-title', @post.slug
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
      base_url = 'http://localhost/'
      Configuration.stubs(:application).returns(stub(:base_url => base_url))
      
      @post.stubs(:slug).returns('post-title')
      
      assert_equal "#{base_url}post-title", @post.permalink
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
