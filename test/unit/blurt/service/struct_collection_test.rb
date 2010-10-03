require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt::Service
  class StructCollectionTest < ActiveSupport::TestCase
    
    context "An instance of the StructCollection class" do
      subject { @subject ||= StructCollection.new }
      
      should "be able to add a definition to the collection" do
        method = lambda {|post| nil }
        assert_equal method, subject.add(:post, &method)
      end
      
      should "raise an error when trying to define a method with no parameters" do
        assert_raise(ArgumentError) { subject.add(:post) { nil } }
      end
      
      should "raise an error when trying to define a method with more than one parameter" do
        assert_raise(ArgumentError) { subject.add(:post) {|one, two| nil } }
      end
      
      should "be able to transform an object to a struct" do
        post = stub() do |p|
          p.stubs(:id).with().returns(1)
          p.stubs(:title).with().returns('Title')
        end

        subject.add(:post) do |post|
          {
            :postId    => post.id,
            :postTitle => post.title
          }
        end
        
        expected = {
          :postId    => 1,
          :postTitle => 'Title'
        }
        
        assert_equal expected, subject.transform(post, :post)
      end
      
    end
    
  end
end
