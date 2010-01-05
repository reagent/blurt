$:.reject! { |e| e.include? 'TextMate' }

root_path = File.expand_path(File.dirname(__FILE__) + '/..')
$:.unshift(root_path)

require 'rubygems'
require 'activerecord'
require 'active_support/test_case'
require 'rack'

require 'test/unit'

require 'shoulda/rails'
require 'factory_girl'

require 'mocha'
require "test/factories"

require 'lib/blurt'

ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql',
  :username => 'root',
  :password => '',
  :database => 'blurt_test'
)

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