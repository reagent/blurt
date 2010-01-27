require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt::Service
  class MovableTypeTest < ActiveSupport::TestCase
    
    context "An instance of the MovableType class" do
      
      should "know how to convert a tag instance into the proper struct" do
        tag = Factory(:tag, :name => 'Tag')
        
        expected = {
          :categoryId   => tag.id.to_s,
          :categoryName => 'Tag'
        }
        
        service = MovableType.new('getCategoryList')
        assert_equal expected, service.to_struct(tag)
      end
      
      should "know how to convert a post instance into a proper struct" do
        post = Factory(:post, :title => 'Title')
        
        expected = {
          :postid      => post.id.to_s,
          :userid      => '1', 
          :title       => 'Title',
          :dateCreated => post.created_at
        }
        
        service = MovableType.new('getRecentPostTitles')
        assert_equal expected, service.to_struct(post)
      end
      
      should "be able to retrieve a list of categories" do
        tag_1 = Factory(:tag, :name => 'A')
        tag_2 = Factory(:tag, :name => 'Z')
        
        service = MovableType.new('getCategoryList')
        
        expected = [
          {:categoryId => tag_1.id.to_s, :categoryName => tag_1.name},
          {:categoryId => tag_2.id.to_s, :categoryName => tag_2.name},
        ]
        
        assert_equal expected, service.getCategoryList('0')
      end
      
      should "be able to retrieve a list of categories for a given post" do
        tag_1 = Factory(:tag, :name => 'One')
        tag_2 = Factory(:tag, :name => 'Two')
        
        post_1 = Factory(:post)
        post_2 = Factory(:post)
        
        post_1.tags << tag_1
        post_2.tags << tag_2
        
        service = MovableType.new('getPostCategories')
        
        expected = [
          {:categoryId => tag_1.id.to_s, :categoryName => tag_1.name, :isPrimary => false}
        ]
        
        assert_equal expected, service.getPostCategories(post_1.id.to_s)
      end
      
      should "be able to set the categories for a given post" do
        post = Factory(:post)
        
        service = MovableType.new('setPostCategories')
        service.setPostCategories(post.id.to_s, %w(A B))
        
        assert_equal %w(A B), post.reload.tag_names
      end
      
      should "be able to update the timestamp on a post" do
        post = Factory(:post, :updated_at => 1.day.ago)
        
        service = MovableType.new('publishPost')
        assert_equal true, service.publishPost(post.id.to_s)
        
        assert_equal Time.now.to_s, post.reload.updated_at.to_s
      end
      
      should "be able to get recent posts" do
        post_1 = Factory(:post, :title => 'Old')
        post_2 = Factory(:post, :title => 'New')
        
        service = MovableType.new('getRecentPostTitles')
        
        service.stubs(:to_struct).with(post_1).returns('struct_1')
        
        assert_equal ['struct_1'], service.getRecentPostTitles('0', 1)
      end
      
      should "be able to get a list of trackbacks for a post"
      should "be able to retrieve a list of supported services"
      
      should_eventually "be able to retrieve a list of supported filters" do
        # need to disable authentication for this one
      end
      
      
      
    end
    
    
  end
end