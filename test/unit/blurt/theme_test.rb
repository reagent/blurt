require File.dirname(__FILE__) + '/../../test_helper'

module Blurt
  class ThemeTest < ActiveSupport::TestCase

    context "An instance of the Theme class" do

      context "when initializing from a name" do
        setup do
          @theme_name = 'blip'
          @root_path  = '/root'
          
          @theme = Theme.new(@theme_name, @root_path)
        end

        should "be able to set the theme name from a symbol" do
          theme = Theme.new(:name, @root_path)
          assert_equal 'name', theme.name
        end

        should "know the path to the theme" do
          assert_equal "/root/themes/blip", @theme.path
        end
        
        should "know the name of the theme" do
          assert_equal @theme_name, @theme.name
        end
        
        should "know the asset path" do
          @theme.expects(:path).returns('/theme_path')
          assert_equal '/theme_path/assets', @theme.asset_path
        end
        
        should "know the view path" do
          @theme.expects(:path).with().returns('/theme_path')
          assert_equal '/theme_path/views', @theme.view_path
        end
      end
      
      context "when initializing from a path" do
        setup do
          @theme_name = 'my_theme'
          @theme_path = "/path/to/#{@theme_name}"
          
          @theme = Theme.new(@theme_path, @root_path)
        end
        
        should "know the path to the theme" do
          assert_equal @theme_path, @theme.path
        end
        
        
      end


    end
  end
end