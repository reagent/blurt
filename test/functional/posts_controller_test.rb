require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase

  context "A GET to :index" do

    context "for HTML content" do
      setup do
        get :index
      end

      should_assign_to :posts
      should_render_template :index
    end

    context "for RSS content" do
      setup do
        get :index, :format => 'rss'
      end
      
      should_assign_to :posts
      should_render_template :index
    end

  end
  
  context "A GET to :show" do
    
    context "with a valid Post slug" do
      setup do
        @post = Factory(:post)
        get :show, :id => @post.slug
      end
    
      should "assign to @post" do
        assert_equal @post, assigns(:post)
      end
      
      should_render_template :show
  
    end
    
    context "without a valid Post slug" do
      setup { get :show, :id => 'missing' }
      should_redirect_to 'root_path'
    end
    
  end

end
