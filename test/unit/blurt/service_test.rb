require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt
  class ServiceTest < ActiveSupport::TestCase
    
    context "An instance of the Service class" do
      
      should "know the username" do
        service = Service.new('newPost', '0', 'username')
        assert_equal 'username', service.username
      end
      
      should "know the password" do
        service = Service.new('newPost', '0', 'username', 'password')
        assert_equal 'password', service.password
      end
      
      should "raise an exception when attempting to authenticate a user whose credentials are incorrect" do
        Blurt.stubs(:configuration).with().returns(stub(:username => 'admin', :password => 'secret'))
        
        service = Service.new('newPost', '0', 'username', 'password')
        assert_raises(Blurt::Service::AuthenticationError) do
          service.authenticate
        end
      end
      
      should "not raise an exception when attempting to authenticate a user with matching credentials" do
        Blurt.stubs(:configuration).with().returns(stub(:username => 'username', :password => 'password'))
        
        service = Service.new('newPost', '0', 'username', 'password')
        assert_nothing_raised { service.authenticate }
      end
      
      should "be able to create a new post" do
        post_struct = {
          'title'       => 'title',
          'description' => 'body',
          'categories'  => %w(One Two)
        }
        
        post = stub(:id => 1)
        
        Post.expects(:create!).with(:title => 'title', :body => 'body', :tag_names => ['One', 'Two']).returns(post)
        
        service = Service.new('newPost', '0', 'username', 'password', post_struct, true)
        
        assert_equal '1', service.newPost
      end
      
      should "be able to retrieve an existing post" do
        post = stub(:to_struct => 'struct')
        Post.expects(:find).with('1').returns(post)
        
        service = Service.new('getPost', '1', 'username', 'password')
        
        assert_equal 'struct', service.getPost
      end
      
      should "be able to edit an existing post" do
        post = Factory(:post, :title => 'title', :body => 'body', :tag_names => ['one'])
        
        params = {
          'title'       => 'new title',
          'description' => 'new body',
          'categories'  => ['two']
        }
        
        service = Service.new('editPost', post.id.to_s, 'username', 'password', params, true)
        service.editPost
        
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
        
        service = Service.new('0', 'username', 'password')
        assert_equal expected, service.getCategories
      end
      
      should "be able to retrieve a list of the recent posts" do
        post_1 = Factory(:post)
        post_1.stubs(:to_struct).with().returns('struct_1')
        
        post_2 = Factory(:post)
        post_2.stubs(:to_struct).with().returns('struct_2')
        
        finder_mock = mock() {|f| f.expects(:with_limit).with(2).returns([post_2, post_1]) }
        
        Post.stubs(:by_date).with().returns(finder_mock)
        
        service = Service.new('getRecentPosts', '0', 'username', 'password', 2)
        assert_equal ['struct_2', 'struct_1'], service.getRecentPosts
      end
      
      should "be able to handle a file upload" do
        media_mock = mock() do |m|
          m.expects(:save!).with()
          m.expects(:to_struct).with().returns('media_struct')
        end
        
        Media.expects(:new).with('struct').returns(media_mock)
        
        service = Service.new('newMediaObject', '0', 'username', 'password', 'struct')
        assert_equal 'media_struct', service.newMediaObject
      end
      
      should "be able to dispatch to the appropriate method with authentication" do
        service = Service.new('newPost', '0', 'username', 'password', {'title' => 'foo'}, true)
        service.expects(:authenticate)
        service.expects(:newPost).with().returns('1')
        
        assert_equal '1', service.call
      end
      
    end
    
  end
end