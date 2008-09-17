class Post < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
  named_scope :by_date, :order => 'created_at DESC'
  
  def content
    Formatter::Code.new(self.body)
  end
end
