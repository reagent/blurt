if RAILS_ENV == 'test'
  THEME_PATH = "#{RAILS_ROOT}/app/themes/default"
else
  require "#{RAILS_ROOT}/lib/configuration"

  Configuration.from_file "#{RAILS_ROOT}/config/blurt.yml"

  PUBLIC_PATH = "#{RAILS_ROOT}/public"
  
  # Accept either a name of a theme or a full path to the theme directory.
  if Configuration.application.theme.index("/")
    THEME_PATH = "#{Configuration.application.theme}"
  else
    THEME_PATH = "#{RAILS_ROOT}/app/themes/#{Configuration.application.theme}"
  end
  

  ASSET_BASE = "#{THEME_PATH}/assets"

  # Purge non-leading dot contents of public directory.
  FileUtils.mkdir("#{PUBLIC_PATH}") if !File.exist?("#{PUBLIC_PATH}")
  dir = Dir.new(PUBLIC_PATH)
  while d=dir.read
    FileUtils.rm_f("#{PUBLIC_PATH}/#{d}") unless d[0,1] == "."
  end
  dir.close
  
  # Symlink all asset files into public since
  # Passenger does not like a symlink in place of the public directory.
  dir = Dir.new(ASSET_BASE)
  while d=dir.read
    File.symlink("#{ASSET_BASE}/#{d}", "#{PUBLIC_PATH}/#{d}") unless d[0,1] == "."
  end
  dir.close
  
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

