class Title
  
  def initialize
    @parts = Array(Configuration.application.name)
  end
  
  def prepend(*elements)
    elements.each {|element| @parts.unshift(element) unless element.nil? }
  end
  
  def to_s
    @parts.join(' | ')
  end
  
end