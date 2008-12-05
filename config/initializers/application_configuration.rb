if RAILS_ENV == 'test'
  THEME_PATH = "#{RAILS_ROOT}/app/themes/default"
else
  require "#{RAILS_ROOT}/lib/configuration"

  Configuration.from_file "#{RAILS_ROOT}/config/blurt.yml"

  THEME_PATH = "#{RAILS_ROOT}/app/themes/#{Configuration.application.theme}"

  FileUtils.mkdir("#{RAILS_ROOT}/public") if !File.exist?("#{RAILS_ROOT}/public")
  FileUtils.rm_rf("#{RAILS_ROOT}/public/*") if File.exist?("#{RAILS_ROOT}/public")
  
  # Symlink all asset files into public since
  # Passenger does not like a symlink in place of the public directory.
  ASSET_BASE = "#{THEME_PATH}/assets"
  dir = Dir.new(ASSET_BASE)
  while d=dir.read
    if d != "." && d != ".."
      File.symlink("#{ASSET_BASE}/#{d}", "#{RAILS_ROOT}/public/#{d}")
    end
  end

  ::ActionController::UrlWriter.module_eval do
    default_url_options[:host]     = Configuration.application.host
    default_url_options[:protocol] = 'http'

    unless Configuration.application.port.nil?
      default_url_options[:port] = Configuration.application.port
    end
  end

end

class ActionController::Base
  self.view_paths = [ "#{THEME_PATH}/views" ]
end

