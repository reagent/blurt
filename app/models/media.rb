class Media

  class UploadError < StandardError; end

  attr_reader :filename, :mime_type

  def initialize(struct)
    @filename  = struct['name']
    @mime_type = struct['type']
    @bits      = struct['bits']
  end

  def data
    Base64.decode64(@bits) unless @bits.nil?
  end

  def subdirectory
    Time.now.strftime('%Y-%m-%d')
  end

  def path
    full_upload_dir = "#{Rails.root}/public/#{Blurt.configuration.upload_dir}"
    "#{full_upload_dir}/#{self.subdirectory}"
  end

  def url
    base_url   = Blurt.configuration.url.to_s.sub(/\/$/, '')
    upload_dir = "#{Blurt.configuration.upload_dir}/#{self.subdirectory}"

    "#{base_url}/#{upload_dir}/#{self.filename}"
  end

  def to_struct
    Api::Struct::Media.new(:url => self.url)
  end

  def save
    begin
      File.open("#{self.path}/#{self.filename}", 'w') {|f| f << self.data }
      true
    rescue
      false
    end
  end

  def save!
    raise UploadError, 'Could not save file' unless self.save
  end

end