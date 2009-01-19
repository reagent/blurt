config_file = "#{Rails.root}/config/blurt_setup.rb"

if File.exist?(config_file)
  require "#{Rails.root}/lib/blurt"
  require config_file
  
  ::ActionController::UrlWriter.module_eval do
    Blurt.configuration.options_for_url_writer.each do |key, value|
      default_url_options[key] = value
    end
  end
  
end

class ActionController::Base
  self.view_paths = [ Blurt.configuration.theme.view_path ]
end