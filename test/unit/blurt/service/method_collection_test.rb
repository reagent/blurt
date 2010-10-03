require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt::Service
  class MethodCollectionTest < ActiveSupport::TestCase
    
    context "An instance of the MethodCollection class" do
      
      subject { @subject ||= MethodCollection.new(stub()) }
      
      should "have an empty collection by default" do
        assert_equal [], subject.names
      end
      
      should "be able to add a method to the collection" do
        method = lambda { nil }
        subject.add(:getPost, &method)
        
        assert_equal({'getPost' => method}, subject.methods)
      end
      
      should "know the names of all methods" do
        subject.add(:getPost) { nil }
        subject.add(:deletePost) { nil }
        
        assert_equal ['deletePost', 'getPost'], subject.names
      end
      
      should "be able to call a method from the collection" do
        subject.add(:getId) { 1 }
        assert_equal 1, subject.call(:getId)
      end
      
      should "be able to call a method with parameters" do
        subject.add(:retrieve) {|value| value }
        assert_equal 12, subject.call(:retrieve, 12)
      end
      
      should "throw an error when trying to call a method that doesn't exist" do
        assert_raise(NoMethodError) { subject.call(:missing) }
      end
      
      should "throw an error when trying to call a method without the proper parameters" do
        subject.add(:methodWithParams) {|one, two| [one, two] }
        
        assert_raise(ArgumentError) { subject.call(:methodWithParams) }
      end

      should "be able to call the correct struct method" do
        post = stub()
        
        namespace = mock()
        namespace.expects(:to_struct).with(:post, post).returns('post')
        
        method_collection = MethodCollection.new(namespace)
        
        method_collection.add(:test) { to_struct(:post, post) }
        
        assert_equal 'post', method_collection.call(:test)
      end
      
      should "delegate authentication to the Service module" do
        method_collection = MethodCollection.new(stub())
        
        Blurt::Service.expects(:authenticate).with('username', 'password')
        method_collection.authenticate('username', 'password')
      end
      
    end
    
  end
end