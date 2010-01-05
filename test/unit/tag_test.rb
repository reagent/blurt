require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class TagTest < ActiveSupport::TestCase

  should_have_many :taggings, :posts
  should_validate_presence_of :name
  
  context "An instance of Tag" do
    
    should "generate a slug before validating" do
      tag = Tag.new
      tag.expects(:generate_slug).with()
      
      tag.valid?
    end
    
    should "be able to generate its own permalink" do
      tag = Tag.new
      tag.stubs(:tag_url).with(tag).returns('permalink')

      assert_equal 'permalink', tag.permalink
    end
    
    should "be able to generate a struct representation of itself" do
      tag = Tag.new(:name => 'Tag')
      
      expected = {
        :description  => 'Tag',
        :htmlUrl      => '',
        :rssUrl       => ''
      }
          
      assert_equal expected, tag.to_struct
    end
    
  end
  
end
