require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase

  should_have_many :taggings
  should_require_attributes :name

  
  context "An instance of Tag" do
    
    should "generate a slug before validating" do
      tag = Tag.new
      tag.expects(:generate_slug).with()
      
      tag.valid?
    end
    
  end
  
end
