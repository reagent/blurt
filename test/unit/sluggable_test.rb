require File.dirname(__FILE__) + '/../test_helper'

class SluggableImplementation
  include Sluggable
end

class SluggableImplementationTest < ActiveSupport::TestCase
  
  def stub_others_by_slug(id, *slugs)
    slugs.each do |slug|
      return_val = (slug == slugs.last) ? nil : stub()
      SluggableImplementation.stubs(:others_by_slug).with(@id, slug).returns(return_val)
    end
  end
  
  context "The SluggableImplmentation class" do
    setup do
      @object = stub()
      @slug   = 'sample-slug'
    end
    
    should "be able to find others by slug when provided an ID" do
      id = 1
      SluggableImplementation.expects(:find_by_slug).with(@slug, {:conditions => ['id != ?', id]}).returns(@object)
      assert_equal @object, SluggableImplementation.others_by_slug(id, @slug)
    end
    
    should "be able to find others by slug when not provided an ID" do
      SluggableImplementation.expects(:find_by_slug).with(@slug, {}).returns(@object)
      assert_equal @object, SluggableImplementation.others_by_slug(nil, @slug)
    end
    
    should "be able to record the column for use when generating the slug" do
      SluggableImplementation.slug_column :title
      @sluggable = SluggableImplementation.new
      
      assert_equal :title, @sluggable.slug_column
    end
    
  end
  
  context "An instance of SluggableImplementation" do
    
    setup do
      @id   = 1
      @slug = 'title'
      
      @sluggable = SluggableImplementation.new
      @sluggable.stubs(:id).returns(@id)
    end
    
    should "define the value in slug returned when converting to_param" do
      param = 'blah'
      @sluggable.expects(:slug).with().returns(param)
      assert_equal param, @sluggable.to_param
    end
    
    should "know the next available slug when the original is taken" do
      stub_others_by_slug(@id, 'title', 'title-2')
      assert_equal "title-2", @sluggable.send(:next_available_slug, 'title')
    end
    
    should "incrementally suggest slugs until it finds an available one" do
      stub_others_by_slug(@id, 'title', 'title-2', 'title-3')
      assert_equal 'title-3', @sluggable.send(:next_available_slug, 'title')
    end
    
    should "know not to suggest an incremental slug when the existing slug belongs to the current record" do
      SluggableImplementation.stubs(:id).with().returns(@id)
      SluggableImplementation.stubs(:others_by_slug).with(@id, @slug).returns(nil)
      
      assert_equal @slug, @sluggable.send(:next_available_slug, @slug)
    end
    
    should "be able to assign a valid slug to the slug property" do
      @sluggable.stubs(:slug_column).with().returns(:title)
      @sluggable.stubs(:title).with().returns(stub(:sluggify => @slug))
      @sluggable.stubs(:next_available_slug).with(@slug).returns(@slug)
      @sluggable.expects(:slug=).with(@slug)
      
      @sluggable.send(:generate_slug)
    end
    
  end
  
end