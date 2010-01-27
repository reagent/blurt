require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt::Service
  class MetaWeblogTest < ActiveSupport::TestCase
    
    context "An instance of the MetaWeblog class" do
      
      should "know how to convert a Post instance into the proper struct" do
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
      
        service = MetaWeblog.new('newPost')
      
        assert_equal expected, service.to_struct(post)
      end
      
      should "know how to convert a Tag instance into the proper struct" do
        tag = Tag.new(:name => 'Tag')
      
        expected = {
          :description  => 'Tag',
          :htmlUrl      => '',
          :rssUrl       => ''
        }
        
        service = MetaWeblog.new('newPost')
        assert_equal expected, service.to_struct(tag)
      end
      
      should "be able to create a new post" do
        post_struct = {
          'title'       => 'title',
          'description' => 'body',
          'categories'  => %w(One Two)
        }
        
        post = stub(:id => 1)
        
        Post.expects(:create!).with(:title => 'title', :body => 'body', :tag_names => ['One', 'Two']).returns(post)
        
        service = MetaWeblog.new('newPost')
        
        assert_equal '1', service.newPost('0', post_struct, true)
      end
      
      should "be able to retrieve an existing post" do
        post = stub()
        Post.expects(:find).with('1').returns(post)
        
        service = MetaWeblog.new('getPost')
        service.stubs(:to_struct).with(post).returns('struct')
        
        assert_equal 'struct', service.getPost('1')
      end
      
      should "be able to edit an existing post" do
        post = Factory(:post, :title => 'title', :body => 'body', :tag_names => ['one'])
        
        post_struct = {
          'title'       => 'new title',
          'description' => 'new body',
          'categories'  => ['two']
        }
        
        service = MetaWeblog.new('editPost')
        service.editPost(post.id.to_s, post_struct, true)
        
        post = Post.find(post.id)
        
        assert_equal 'new title', post.title
        assert_equal 'new body', post.body
        assert_equal ['two'], post.tag_names
        
      end
      
      should "be able to retrieve the list of categories" do
        tag_1 = Factory(:tag, :name => 'B')
        tag_2 = Factory(:tag, :name => 'A')
        
        expected = [
          {:description => 'A', :htmlUrl => '', :rssUrl => ''},
          {:description => 'B', :htmlUrl => '', :rssUrl => ''},
        ]
        
        service = MetaWeblog.new('getCategories')
        assert_equal expected, service.getCategories('0')
      end
      
      should "be able to retrieve a list of the recent posts" do
        post_1, post_2 = stub(), stub()
        
        finder_mock = mock() {|f| f.expects(:with_limit).with(2).returns([post_2, post_1]) }
        
        Post.stubs(:by_date).with().returns(finder_mock)
        
        service = MetaWeblog.new('getRecentPosts')
        service.stubs(:to_struct).with(post_2).returns('struct_2')
        service.stubs(:to_struct).with(post_1).returns('struct_1')
        
        assert_equal ['struct_2', 'struct_1'], service.getRecentPosts('0', 2)
      end
      
      should "be able to handle a file upload" do
        media_mock = mock() do |m|
          m.expects(:save!).with()
          m.expects(:to_struct).with().returns('media_struct')
        end
        
        Media.expects(:new).with('struct').returns(media_mock)
        
        service = MetaWeblog.new('newMediaObject')
        assert_equal 'media_struct', service.newMediaObject('0', 'struct')
      end
      
    end
    
  end
end