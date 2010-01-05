module Blurt
  class Theme
    
    attr_reader :name, :path
    
    def initialize(name_or_path, root_path)
      parts = name_or_path.to_s.split('/')
      @root_path = root_path
      
      @name = parts.last
      @path = parts.join('/') if parts.length > 1
    end
    
    def path
      @path ||= "#{@root_path}/themes/#{@name}"
    end
    
    def asset_path
      "#{self.path}/assets"
    end
    
    def view_path
      "#{self.path}/views"
    end
    
  end
end