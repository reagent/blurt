class Title
  
  def initialize
    @parts = Array(Blurt.configuration.name)
  end
  
  def prepend(*elements)
    elements.each {|element| @parts.unshift(element) unless element.nil? }
  end
  
  def to_s
    @parts.join(' | ')
  end
  
end