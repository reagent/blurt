module Blurt
  class Configuration
    
    attr_accessor :name, :tagline, :per_page, :upload_dir
    attr_reader   :theme, :url, :username, :password
    
    def initialize(root_path)
      @root_path = root_path
      @theme = Theme.new(:default, @root_path)
    end
    
    def theme=(theme_name)
      @theme = Theme.new(theme_name, @root_path)
    end
    
    # TODO: might not need to split this anymore
    def url=(url)
      @url = URI.parse(url)
    end
    
    def credentials=(credentials)
      @username, @password = credentials.split(':')
    end
    
    def upload_path
      "#{self.public_path}/#{@upload_dir}" unless self.upload_dir.nil?
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
    
    def create_upload_directory!
      if !self.upload_path.nil? && !File.exist?(self.upload_path)
        FileUtils.mkdir(self.upload_path)
      end
    end
    
    def public_files
      Dir["#{self.public_path}/*"] - [self.upload_path]
    end
    
    def asset_files
      Dir["#{self.theme.asset_path}/*"].inject({}) {|result, f| result.merge(f => File.basename(f)) }
    end
    
    def prepare_public_directory!
      self.create_upload_directory!

      self.public_files.each {|f| FileUtils.rm_rf(f) }
      self.asset_files.each {|path, link_name| File.symlink(path, "#{self.public_path}/#{link_name}") }
    end
  end
end