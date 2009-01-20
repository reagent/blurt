require File.dirname(__FILE__) + '/../../test_helper'

class Api::ServiceTest < ActiveSupport::TestCase

  context "An instance of Api::Service" do

    setup do
      @username = 'reagent'
      @password = 'fluffybunnies'
      @attributes = {:title => 'Title', :description => 'Description', :categories => ['category']}

      @service = Api::Service.new
      @post_struct = Api::Struct::Post.new(@attributes)
    end

    context "when creating a new post" do

      setup do
        @post_count = Post.count
        @new_post_method = lambda { @service.newPost(0, @username, @password, @post_struct, true) }
      end

      context "as an authenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
          @response = @new_post_method.call
          @new_post = Post.last
        end

        should "increment the post count" do
          assert_equal @post_count + 1, Post.count
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
        
        should "assign the proper tags to the new post" do
          assert_equal @attributes[:categories], @new_post.tag_names
        end
      end

      context "as an unauthenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).raises(Api::Service::UnauthenticatedError)
        end

        should "not increment the post count" do
           @new_post_method.call rescue nil
          assert_equal @post_count, Post.count
        end

        should "raise an exception" do
          assert_raise(Api::Service::UnauthenticatedError) { @new_post_method.call }
        end

      end

    end

    context "when retrieving an existing post" do

      setup do
        @get_post_method = lambda {|post| @service.getPost(post.id, @username, @password) }
        @post = Factory(:post, :title => 'Title', :body => 'Body')
      end

      context "as an authenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
          @response = @get_post_method.call(@post)
        end

        should "have the correct title" do
          assert_equal 'Title', @response['title']
        end

        should "have the correct :description" do
          assert_equal 'Body', @response['description']
        end
      end

      context "as an unauthenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).raises(Api::Service::UnauthenticatedError)
        end

        should "raise an exception" do
          assert_raise(Api::Service::UnauthenticatedError) { @get_post_method.call(@post) }
        end

      end

    end

    context "when editing an existing post" do

      setup do
        @edit_post_method = lambda {|post| @service.editPost(post.id, @username, @password, @post_struct, true) }
        @post = Factory(:post, :title => 'Title', :body => 'Body')
      end

      context "as an authenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
        end

        should "return true" do
          assert_equal true, @edit_post_method.call(@post)
        end

        should "update the existing post" do
          update_attributes = {
            :title     => @attributes[:title], 
            :body      => @attributes[:description],
            :tag_names => @attributes[:categories]
          }
          Post.any_instance.expects(:update_attributes).with(update_attributes)
          @edit_post_method.call(@post)
        end
      end

      context "as an unauthenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).raises(Api::Service::UnauthenticatedError)
        end

        should "raise an exception" do
          assert_raise(Api::Service::UnauthenticatedError) { @edit_post_method.call(@post) }
        end

        should "not update any posts" do
          Post.any_instance.expects(:update_attributes).with(kind_of(Hash)).never
          @edit_post_method.call(@post) rescue nil
        end

      end

    end

    context "when retrieving latest posts" do

      setup do
        @get_recent_posts_method = lambda {|post_count| @service.getRecentPosts(0, @username, @password, post_count)}
      end

      context "as an authenticated user" do

        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
          
          @title = 'This is a title'
          @body  = 'This is a body'
        end

        context "with a single post" do
          setup do
            @post  = Factory(:post, :title => @title, :body => @body)
          end

          should "contain an array of posts" do
            assert_kind_of Array, @get_recent_posts_method.call(1)
          end

          should "match the list of available posts" do
            posts = @get_recent_posts_method.call(1)
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
            assert_equal 1, @get_recent_posts_method.call(1).length
          end

          should "return the most recent post first" do
            most_recent_post = Post.find(:first, :order => 'created_at DESC')
            posts = @get_recent_posts_method.call(Post.count)

            assert_equal most_recent_post.title, posts.first['title']
          end

        end
      end
      
      context "as an unauthenticated user" do

        setup do
          Factory(:post)
          @service.stubs(:authenticate!).with(@username, @password).raises(Api::Service::UnauthenticatedError)
        end

        should "raise an exception" do
          assert_raise(Api::Service::UnauthenticatedError) { @get_recent_posts_method.call(1) }
        end

      end
      
    end
    
    context "when retrieving the category list" do
      
      context "as an authenticated user" do
        
        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
          @get_categories_method = lambda { @service.getCategories(0, @username, @password) }
        end
        
        should "return an array of categories" do
          assert_kind_of Array, @get_categories_method.call
        end
        
        should "have the proper category in the list" do
          tag = Factory(:tag)
          assert_equal tag.name, @get_categories_method.call.first['description']
        end
        
        should "sort the list by name when there are multiple categories" do
          Factory(:tag, :name => 'b')
          Factory(:tag, :name => 'a')
          
          assert_equal %w(a b), @get_categories_method.call.map {|category| category['description']}
          
        end
        
      end
      
    end
    
    context "when uploading a media file" do
      context "as an authenticated user" do
        setup do
          @service.stubs(:authenticate!).with(@username, @password).returns(true)
          @struct = Api::Struct::Media.new(:name => 'foo.jpg', :type => 'image/jpeg', :bits => '123')
          @new_media_method = lambda { @service.newMediaObject(0, @username, @password, @struct) }
        end
        
        should "save the media file" do
          media_model = mock do |m| 
            m.expects(:save!).with()
            m.stubs(:to_struct)
          end
          ::Media.expects(:new).with(@struct).returns(media_model)
          
          @new_media_method.call
        end
        
        should "return a struct that represents the new file" do
          media_model = mock do |m|
            m.stubs(:save!).with()
            m.expects(:to_struct).with().returns('struct')
          end
          
          ::Media.expects(:new).returns(media_model)
          
          assert_equal 'struct', @new_media_method.call
        end
      end
    end

  end

end