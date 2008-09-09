require File.dirname(__FILE__) + '/../../test_helper'

class Api::ServiceTest < ActiveSupport::TestCase
  
  context "An instance of Api::Service" do
    
    setup do
      @attributes = {:title => 'Title', :description => 'Description'}
      @service = Api::Service.new
      @post_struct = Api::Struct::Post.new(@attributes)
    end

    context "when creating a new post" do
      
      setup do
        @initial_count = Post.count
        @response = @service.newPost(0, 'username', 'password', @post_struct, true)
        @new_post = Post.last
      end
      
      should "increment the post count" do
        assert_equal @initial_count + 1, Post.count
      end
      
      should "return the ID of the new post" do
        assert_equal @new_post.id.to_s, @response
      end
      
      should "assign the proper :title to the new post" do
        assert_equal @attributes[:title], @new_post.title
      end
      
      should "assign the proper :body to the new post" do
        assert_equal @attributes[:description], @new_post.body
      end

    end

    context "when retrieving an existing post" do
      
      setup do
        post = Factory(:post, :title => 'Title', :body => 'Body')
        @response = @service.getPost(post.id, 'username', 'password')
      end
      
      should "have the correct title" do
        assert_equal 'Title', @response['title']
      end
      
      should "have the correct :description" do
        assert_equal 'Body', @response['description']
      end
      
    end
    
    context "when editing an existing post" do
      
      setup do
        post = Factory(:post, :title => 'Title', :body => 'Body')
        @method = lambda { @response = @service.editPost(post.id, 'username', 'password', @post_struct, true) }
      end
      
      should "return true" do
        @method.call
        assert_equal true, @response
      end
      
      should "update the existing post" do
        Post.any_instance.expects(:update_attributes).with(:title => @attributes[:title], :body => @attributes[:description])
        @method.call
      end
      
    end
    
  end
  
end