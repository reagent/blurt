require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PostTest < ActiveSupport::TestCase

  should_validate_presence_of :title, :body
  
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
      Blurt::Formatter.stubs(:new).with(body).returns(formatter)
      
      assert_equal formatter, @post.content
    end
    
    should "be able to generate the RSS representation of itself" do
      post = Post.new(:title => 'Title')
      post.stubs(:content).with().returns(stub(:to_html => 'html'))
      post.stubs(:created_at).with().returns(Time.parse('2009-08-01 00:00:00'))
      post.stubs(:permalink).with().returns('permalink')
      
      expected = <<-RSS
    <item>
      <title>Title</title>
      <description>html</description>
      <pubDate>Sat, 01 Aug 2009 00:00:00 -0400</pubDate>
      <link>permalink</link>
      <guid>permalink</guid>
    </item>
      RSS
  
      assert_equal expected, post.to_rss
      
    end
    
    should "have a list of assigned tag names" do
      @post.tag_names = ['tag']
      assert_equal ['tag'], @post.tag_names
    end
    
    should "default the list of tag names to an empty array" do
      assert_equal [], @post.tag_names
    end
    
    should "clear the tag list when setting the tag names to nil" do
      @post.tag_names = nil
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
    
    should "pull its tag names from the database when reloaded" do
      @post = Factory(:post, :tag_names => ['a'])
      @post.tag_names = ['b', 'c']
      
      @post.reload
      
      assert_equal ['a'], @post.tag_names
    end
    
    should "generate a slug before the post is validated" do
      @post.expects(:generate_slug)
      @post.valid?
    end
    
    should "be able to generate its own permalink" do
      @post.stubs(:post_url).with(@post).returns('permalink')
      assert_equal 'permalink', @post.permalink
    end
    
    should "be able to generate a struct representation of itself" do
      post = Factory.build(:post, :title => 'Post', :body => 'body')
      post.tags.build(:name => 'Tag')

      post.save
      post.stubs(:permalink).with().returns('permalink')

      expected = {
        :postid      => post.id.to_s,
        :title       => 'Post',
        :categories  => ['Tag'],
        :permaLink   => 'permalink',
        :description => 'body',
        :dateCreated => post.created_at
      }
      
      assert_equal expected, post.to_struct
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
