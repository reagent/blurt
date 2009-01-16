module Blurt
  class Configuration
    
    attr_accessor :name, :tagline
    attr_reader   :theme, :url, :username, :password
    attr_writer   :upload_dir
    
    def initialize(root_path)
      @root_path = root_path
    end
    
    def theme=(theme_name)
      @theme = Theme.new(theme_name, @root_path)
    end
    
    def url=(url)
      @url = URI.parse(url)
    end
    
    def credentials=(credentials)
      @username, @password = credentials.split(':')
    end
    
    def upload_dir
      "#{self.public_path}/#{@upload_dir}"
    end
    
    def public_path
      "#{@root_path}/public"
    end
    
    def options_for_url_writer
      options = {
        :protocol => self.url.scheme,
        :host     => self.url.host
      }
      
      options.merge!(:port => self.url.port) unless self.url.port == 80
      options
    end
    
    def move_asset_files!
      files_to_remove = Dir["#{self.public_path}/*"] - [self.upload_dir]
      files_to_remove.each {|file| FileUtils.rm_rf(file) }
      Dir["#{self.theme.asset_path}/*"].each {|f| File.symlink(f, "#{self.public_path}/#{File.basename(f)}") }
    end
    private :move_asset_files!
  end
end