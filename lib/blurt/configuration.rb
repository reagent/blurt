module Blurt
  class Configuration
    
    attr_accessor :name, :tagline, :per_page, :connection
    attr_writer   :upload_dir
    attr_reader   :theme, :url, :username, :password
    
    def initialize(root_path)
      @root_path = root_path
      @theme = Theme.new(:default, @root_path)
    end
    
    def theme=(theme_name)
      @theme = Theme.new(theme_name, @root_path)
    end
    
    def url=(url)
      @url = url.sub(/\/+$/, '')
    end
    
    def credentials=(credentials)
      @username, @password = credentials.split(':')
    end
    
    def upload_dir
      @upload_dir ||= 'uploads'
    end
    
    def upload_path
      "#{@root_path}/#{@upload_dir}" unless self.upload_dir.nil?
    end
  
    def create_upload_directory
      FileUtils.mkdir(self.upload_path) unless File.exist?(upload_path)
    end
    
    def connect_to_database
      ActiveRecord::Base.establish_connection(connection)
    end
    
    def boot
      create_upload_directory
      connect_to_database
    end

  end
end