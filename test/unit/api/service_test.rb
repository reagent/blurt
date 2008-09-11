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

    context "when retrieving latest posts" do

      setup do
        @title = 'This is a title'
        @body  = 'This is a body'
      end

      context "with a single post" do
        setup do
          @post  = Factory(:post, :title => @title, :body => @body)
        end

        should "contain an array of posts" do
          assert_kind_of Array, @service.getRecentPosts(0, 'username', 'password', 1)
        end

        should "match the list of available posts" do
          posts = @service.getRecentPosts(0, 'username', 'password', 1)
          assert_equal [@title, @body], [posts.first['title'], posts.first['description']]
        end
      end
      
      context "with multiple posts" do
        setup do
          2.times do |i|
            post = Factory(:post, :title => i.to_s)
            post.update_attribute(:created_at, i.day.from_now)
          end
        end
        
        should "return only the specified number of posts" do
          assert_equal 1, @service.getRecentPosts(0, 'username', 'password', 1).length
        end
        
        should "return the most recent post first" do
          most_recent_post = Post.find(:first, :order => 'created_at DESC')
          posts = @service.getRecentPosts(0, 'username', 'password', Post.count)

          assert_equal most_recent_post.title, posts.first['title']
        end
        
      end
      
    end

  end

end