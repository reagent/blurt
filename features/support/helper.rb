module Helper

  def evaluate_fixture(basename, options = {})
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    fixture_file = "#{basename}.fixture"
    
    erb = ERB.new(IO.read("#{fixture_path}/#{fixture_file}"))
    erb.result(binding)
  end
  
  def response_header(key)
    Capybara.current_session.response_headers[key]
  end
  
end