require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase

  context "A GET to :index" do
    
    setup do
      Configuration.stubs(:application).returns(stub(:name => 'blurt'))
      get :index 
    end
    
    should_assign_to :tags
    should_respond_with :success
    should_render_template :index
    
  end
  
  context "A GET to :show" do
    
    setup do
      Configuration.stubs(:application).returns(stub(:name => 'blurt'))
      @tag = Factory(:tag)
    end
    
    context "with a valid slug" do
      
      setup { get :show, :slug => @tag.slug }
      
      should_assign_to :tag
      should_respond_with :success
      should_render_template :show
      
    end
    
    context "with an invalid slug" do
      
      setup { get :show, :slug => 'nun' }
      
      should_redirect_to 'tags_path'
      
    end
    
  end

end
