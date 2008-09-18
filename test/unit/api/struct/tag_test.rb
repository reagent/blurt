require File.dirname(__FILE__) + '/../../../test_helper'

class Api::Struct::TagTest < ActiveSupport::TestCase
  
  context "The Api::Struct::Tag class" do
    
    context "when instantiating itself from an ActiveRecord instance" do
      
      setup do
        @tag         = Factory(:tag)
        @tag_struct  = Api::Struct::Tag.from_active_record(@tag)
      end
    
      should "have a :description" do
        assert_equal @tag.name, @tag_struct['description']
      end
      
      should "have an :htmlUrl" do
        assert_equal '', @tag_struct['htmlUrl']
      end
      
      should "have an :rssUrl" do
        assert_equal '', @tag_struct['rssUrl']
      end
    
    end
    
  end
  
end