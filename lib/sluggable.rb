module Sluggable
  module ClassMethods
    
    def others_by_slug(id, slug)
      conditions = id.nil? ? {} : {:conditions => ['id != ?', id]}
      find_by_slug(slug, conditions)
    end
    
    def slug_column(column)
      define_method(:slug_column) do
        column
      end
    end
    
  end
  
  module InstanceMethods
    
    def next_available_slug(base_slug)
      valid_slug = base_slug

      index = 2
      while self.class.others_by_slug(self.id, valid_slug)
        valid_slug = base_slug + "-#{index}"
        index+= 1
      end
      valid_slug
    end
    
    def generate_slug
      self.slug = next_available_slug(self.send(slug_column).sluggify)
    end
    
    private :next_available_slug, :generate_slug
    
  end
  
  def self.included(other)
    other.send(:extend, Sluggable::ClassMethods)
    other.send(:include, Sluggable::InstanceMethods)
  end
  
end