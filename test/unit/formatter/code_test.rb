require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module Formatter

  class CodeTest < ActiveSupport::TestCase

    def read_fixture(name, type)
      fixture_path = File.dirname(__FILE__) + '/../../fixtures'
      File.read("#{fixture_path}/formatter/code/#{name}.#{type}")
    end

    context "An instance of the Formatter::Code class" do

      should "render the correct markdown" do
        code = Code.new(read_fixture('simple_text', :string))
        assert_equal read_fixture('simple_text', :html), code.to_html
      end

      should "render a valid code block" do
        code = Code.new(read_fixture('code', :string))
        assert_equal read_fixture('code', :html), code.to_html
      end
      
      should "render markdown mixed with code" do
        code = Code.new(read_fixture('mixed', :string))
        assert_equal read_fixture('mixed', :html), code.to_html
      end

      should "display the source content when calling to_s" do
        content = 'source content'
        assert_equal content, Code.new(content).to_s
      end
      
    end

  end
  
end
