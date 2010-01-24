module Helper

  def path_to_fixture(name)
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    "#{fixture_path}/#{name}"
  end

  def evaluate_fixture(basename, options = {})
    fixture_file = path_to_fixture("#{basename}.fixture")
    
    options.symbolize_keys!
    
    erb = ERB.new(IO.read(fixture_file), 0, '<>')
    erb.result(binding)
  end
  
  def response_header(key)
    Capybara.current_session.response_headers[key]
  end

  def post(endpoint, data)
    session = Capybara.current_session
    driver = session.driver

    driver.post(endpoint, data)
  end
  
  def call_api(method_name, *parameters)
    xml = XMLRPC::Marshal.dump_call(method_name, *parameters)
    post '/admin', xml
  end

  def most_recent_post
    Post.first(:order => 'id DESC')
  end
  
  def api_response
    XMLRPC::Marshal.load(@last_response.body)
  end

  def assert_status(expected_code)
    assert_equal expected_code.to_i, @last_response.status
  end
  
  def assert_post_without_date(expected_post, api_response)
    post = expected_post
    
    expected_values = {
      'permaLink'   => post.permalink,
      'title'       => post.title,
      'categories'  => post.tag_names,
      'description' => post.body
    }
    
    expected_values.each do |key, value|
      assert_equal value, api_response[key]
    end
  end

end