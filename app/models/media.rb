class Media

  class UploadError < StandardError; end

  attr_reader :filename, :mime_type

  def initialize(struct)
    @filename  = struct['name']
    @mime_type = struct['type']
    @bits      = struct['bits']
  end

  def data
    @bits
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
      self.create_path!
      File.open("#{self.path}/#{self.filename}", 'w') {|f| f << self.data }
      true
    rescue
      false
    end
  end

  def create_path!
    FileUtils.mkdir(self.path) unless File.exist?(self.path)
  end

  def save!
    raise UploadError, "Could not save file" unless self.save
  end

end