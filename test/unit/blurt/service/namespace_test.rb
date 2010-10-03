require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module Blurt
  module Service
    class NamespaceTest < ActiveSupport::TestCase
      
      context "An instance of the Namespace class" do
        subject { @subject ||= Namespace.new('') }
        
        should "have a name" do
          assert_equal :name, Namespace.new(:name).name
        end
        
        should "have an empty list of methods by default" do
          assert_equal [], subject.methods
        end
        
        should "be able to add a method to the collection" do
          namespace = Namespace.new(:system)
          namespace.method(:echo) {|message| message }
          
          assert_equal ['system.echo'], namespace.methods
        end
        
        should "be able to call a method that has been added to the collection" do
          subject.method(:getPost) { 12 }
          assert_equal 12, subject.call(:getPost)
        end
        
        should "be able to call a method added to the collection with parameters" do
          subject.method(:getPost) {|id| id }
          assert_equal 42, subject.call(:getPost, 42)
        end
        
        should "be able define a struct method" do
          post = stub(:id => 1)
          
          subject.struct(:post) {|post| {:postId => post.id} }
          
          assert_equal({:postId => 1}, subject.to_struct(:post, post))
        end
        
        
      end
      
      
    end
  end
end