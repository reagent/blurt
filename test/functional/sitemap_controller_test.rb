require 'test_helper'

class SitemapControllerTest < ActionController::TestCase

  context "A GET to :show" do
    setup do
      get :show, :format => 'xml'
    end
    
    should_assign_to :sitemap
    should_respond_with :success
  end

end


