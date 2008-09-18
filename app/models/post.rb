class Post < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :by_date, :order => 'created_at DESC'
  named_scope :with_limit, lambda {|limit| {:limit => limit} }
  
  def content
    Formatter::Code.new(self.body)
  end
end
