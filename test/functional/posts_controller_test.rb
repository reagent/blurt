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

end
