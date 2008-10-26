class String
  def sluggify
    slug = self.downcase.gsub(/[^0-9a-z_ -]/i, '')
    slug = slug.gsub(/\s+/, '-')
    slug
  end
end