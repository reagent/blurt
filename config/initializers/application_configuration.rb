if RAILS_ENV == 'test'
  THEME_PATH = "#{RAILS_ROOT}/app/themes/default"
else
  require "#{RAILS_ROOT}/lib/configuration"
  
  Configuration.from_file "#{RAILS_ROOT}/config/blurt.yml"

  THEME_PATH = "#{RAILS_ROOT}/app/themes/#{Configuration.application.theme}"

  FileUtils.rm_rf("#{RAILS_ROOT}/public") if File.exist?("#{RAILS_ROOT}/public")
  File.symlink("#{THEME_PATH}/assets", "#{RAILS_ROOT}/public")
  
  ::ActionController::UrlWriter.module_eval do
    default_url_options[:host]     = Configuration.application.host
    default_url_options[:port]     = Configuration.application.port
    default_url_options[:protocol] = 'http'
  end
  
end

class ActionController::Base
  self.view_paths = [ "#{THEME_PATH}/views" ]
end

