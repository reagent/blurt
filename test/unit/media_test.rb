require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class MediaTest < ActiveSupport::TestCase

  context "An instance of the Media class" do
    context "when initializing itself from a MetaWeblog Struct" do
      setup do
        @struct = {'name' => 'foo.jpg', 'type' => 'image/jpeg', 'bits' => 'bitty'} 
        @media  = ::Media.new(@struct)
      end

      should "have a value for :filename" do
        assert_equal 'foo.jpg', @media.filename
      end
      
      should "have a value for :mime_type" do
        assert_equal 'image/jpeg', @media.mime_type
      end

      should "have a value for :data" do
        assert_equal 'bitty', @media.data
      end

      should "know the subdirectory path" do
        time = Time.parse('2009-08-01 00:00:00')
        Time.expects(:now).at_least_once.with().returns(time)
        
        assert_equal '2009-08', @media.subdirectory
      end

      should "know the path to save files" do
        Blurt.stubs(:root).with().returns('/projects/blurt')
        Blurt.expects(:configuration).with().returns(stub(:upload_dir => 'uploads'))
        @media.expects(:subdirectory).with().returns('2009-08-01')

        assert_equal '/projects/blurt/public/uploads/2009-08-01', @media.path
      end
      
      should "create the upload path" do
        @media.expects(:path).at_least_once.with().returns('/uploads')
        FileUtils.expects(:mkdir).with('/uploads')
        
        @media.create_path!
      end
      
      should "not create the upload path if it exists" do
        @media.expects(:path).at_least_once.with().returns('/uploads')
        
        File.expects(:exist?).with('/uploads').returns(true)
        FileUtils.expects(:mkdir).with('/uploads').never
        
        @media.create_path!
      end
      
      should "create the path when saving the file" do
        @media.expects(:create_path!)
        File.stubs(:open)
        
        @media.save
      end
      
      should "be able to save the file to disk" do
        @media.stubs(:filename).with().returns('my_file.jpg')
        @media.stubs(:data).with().returns('data')
        @media.stubs(:path).with().returns('/upload')
        
        file = mock {|m| m.expects(:<<).with('data') }
        
        File.expects(:open).with('/upload/my_file.jpg', 'w').yields(file)
        
        assert_equal true, @media.save
      end
      
      should "return false if it can't save the file" do
        @media.stubs(:path).with().returns('/path')
        @media.stubs(:filename).with().returns('file')
        
        File.expects(:open).with('/path/file', 'w').raises(Errno::EACCES)
        assert_equal false, @media.save
      end
      
      should "raise an exception if the file can't be saved (when calling save!)" do
        @media.expects(:save).with().returns(false)
        assert_raise(::Media::UploadError) do
          @media.save!
        end
      end
      
      should "Return the URL for the saved file" do
        url = stub(:to_s => 'http://blurt.net/')
        
        configuration = mock do |m|
          m.expects(:url).with().returns(url)
          m.expects(:upload_dir).with().returns('uploads')
        end
        
        Blurt.expects(:configuration).at_least_once().with().returns(configuration)
        
        @media.expects(:filename).with().returns('foo.jpg')
        @media.expects(:subdirectory).with().returns('2009-08-01')
        
        assert_equal 'http://blurt.net/uploads/2009-08-01/foo.jpg', @media.url
      end
      
      should "be able to generate the struct representation of itself" do
        @media.stubs(:url).with().returns('url')
        
        assert_equal({:url => 'url'}, @media.to_struct)
      end
      
    end

  end
end