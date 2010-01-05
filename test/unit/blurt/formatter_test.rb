require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Blurt

  class FormatterText < ActiveSupport::TestCase

    def read_fixture(name, type)
      fixture_path = File.dirname(__FILE__) + '/../../fixtures'
      File.read("#{fixture_path}/formatter/#{name}.#{type}")
    end

    context "An instance of the Formatter class" do

      should "render the correct markdown" do
        formatter = Formatter.new(read_fixture('simple_text', :string))
        assert_equal read_fixture('simple_text', :html), formatter.to_html
      end

      should "render a valid code block" do
        formatter = Formatter.new(read_fixture('code', :string))
        assert_equal read_fixture('code', :html), formatter.to_html
      end
      
      should "render markdown mixed with code" do
        formatter = Formatter.new(read_fixture('mixed', :string))
        assert_equal read_fixture('mixed', :html), formatter.to_html
      end

      should "display the source content when calling to_s" do
        content = 'source content'
        assert_equal content, Formatter.new(content).to_s
      end
      
    end

  end
  
end
