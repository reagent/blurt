require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/**/*.rb']
  t.verbose = true
end

def load_environment(environment)
  suffix = "_#{environment}" if environment
  
  begin
    require File.dirname(__FILE__) + '/lib/blurt'
    require "#{Blurt.root}/config/setup#{suffix}"
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  rescue LoadError
    puts "Please configure config/setup#{suffix}.rb"
    exit 1
  end
end

namespace :db do
  
  desc "Create the database in the specified environment"
  task :create, :environment do |t, args|
    load_environment(args[:environment])
    config = Blurt.configuration.connection
    
    ActiveRecord::Base.establish_connection(config.merge('database' => nil))
    ActiveRecord::Base.connection.create_database(config['database'])
    ActiveRecord::Base.establish_connection(config)
  end
  
  desc "Drop the database in the specified environment"
  task :drop, :environment do |t, args|
    load_environment(args[:environment])
    config = Blurt.configuration.connection
    
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection.drop_database config['database']
  end
  
  desc "Migrate the database"
  task :migrate, :environment do |t, args|
    load_environment(args[:environment])
    ActiveRecord::Migrator.migrate("db/migrate/")
  end
  
  desc "Remigrate the database from scratch"
  task :reset, :environment do |t, args|
    %w(drop create migrate).each do |name|
      Rake::Task["db:#{name}"].invoke(args[:environment])
    end
  end
  
end