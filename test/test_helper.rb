$:.reject! { |e| e.include? 'TextMate' }

ENV['RACK_ENV'] = 'test'

root_path = File.expand_path(File.dirname(__FILE__) + '/..')
$:.unshift(root_path)

require 'rubygems'
require 'active_support/test_case'
require 'rack'

require 'test/unit'
require 'mocha'
require 'factory_girl'
require 'test/factories'

require 'config/boot'

require 'shoulda/rails'

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