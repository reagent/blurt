class Title

  delegate :prepend, :append, :to => :@parts

  def initialize
    @parts = []
  end

  def to_s
    @parts.join(' | ')
  end

end
