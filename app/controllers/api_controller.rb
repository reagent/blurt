class ApiController < ActionController::Base
  session :off
  
  web_service_dispatching_mode :layered
  web_service(:metaWeblog) { Api::Service.new }
end