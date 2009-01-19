require File.dirname(__FILE__) + '/../../../test_helper'

class Api::Struct::MediaTest < ActiveSupport::TestCase
  
  context "An instance of the Api::Struct::Media class" do
    setup do
      @media_struct = Api::Struct::Media.new(
        :name => 'foo.jpg', 
        :type => 'image/jpeg', 
        :bits => 'bit',
        :url  => 'http://url.com'
      )
    end
    
    should "have a reader for :name" do
      assert_equal 'foo.jpg', @media_struct['name']
    end
    
    should "have a reader for :type" do
      assert_equal 'image/jpeg', @media_struct['type']
    end
    
    should "have a reader for :bits" do
      assert_equal 'bit', @media_struct['bits']
    end
    
    should "have a reader for :url" do
      assert_equal 'http://url.com', @media_struct['url']
    end
    
  end
  
end