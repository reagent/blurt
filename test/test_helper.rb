$:.reject! { |e| e.include? 'TextMate' }

ROOT = File.expand_path(File.dirname(__FILE__) + '/..')
$:.unshift(ROOT)


require 'rubygems'
require 'activerecord'
require 'active_support/test_case'
require 'rack'

require 'test/unit'

require 'shoulda/rails'
require 'factory_girl'

require 'BlueCloth'
require 'hpricot'

require 'xmlrpc/marshal'

gem 'coderay', '= 0.7.4.215'
require 'coderay'

require 'mocha'
require "#{ROOT}/test/factories"

require 'lib/formatter/code'
require 'lib/core_ext/nil_class'
require 'lib/core_ext/string'
require 'lib/sluggable'
require 'lib/blurt'
require 'lib/blurt/request_handler'
require 'lib/blurt/service'
require 'lib/blurt/configuration'
require 'lib/blurt/theme'
require 'lib/blurt/helpers/url_helper'
require 'lib/blurt/helpers/link_helper'
require 'lib/title'

require 'models/tag'
require 'models/tagging'
require 'models/media'
require 'models/paginated_post'
require 'models/post'
require 'models/sitemap'

# config/
# models/
# lib/
# views/
# helpers/
# db/
# log/
# test/
# application.rb
# blurt.rb

database_config = YAML.load_file("#{ROOT}/config/database.yml")
ActiveRecord::Base.establish_connection(database_config['test'])

class ActiveSupport::TestCase

  setup :begin_transaction
  teardown :rollback_transaction

  def begin_transaction
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.transaction_joinable = false
    ActiveRecord::Base.connection.begin_db_transaction
  end
  
  def rollback_transaction
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions

    ActiveRecord::Base.clear_active_connections!
  end

end