require "#{RAILS_ROOT}/lib/configuration"
Configuration.from_file "#{RAILS_ROOT}/config/blurt.yml"

THEME_PATH = "#{RAILS_ROOT}/app/themes/#{Configuration.application.theme}"

FileUtils.rm_rf("#{RAILS_ROOT}/public") if File.exist?("#{RAILS_ROOT}/public")
File.symlink("#{THEME_PATH}/assets", "#{RAILS_ROOT}/public")

class ActionController::Base
  self.view_paths = [ "#{THEME_PATH}/views" ]
end

