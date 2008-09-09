require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase

  context "A GET to :index" do
    
    setup do
      get :index
    end
    
    should_assign_to :posts
    should_render_template :index
    
  end

end
