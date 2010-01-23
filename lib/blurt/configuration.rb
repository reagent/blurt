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
    
    def environment_file
      "#{Blurt.root}/config/setup/#{Blurt.env}.rb"
    end
    
    def read_environment_file
      File.exist?(environment_file) ? IO.read(environment_file) : nil
    end
    
    def load_environment
      environment_contents = read_environment_file

      unless environment_contents.nil?
        config = self
        eval read_environment_file, binding
      end
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
      load_environment
      create_upload_directory
      connect_to_database
    end

  end
end