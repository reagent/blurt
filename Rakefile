require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/**/*.rb']
  t.verbose = true
end

namespace :db do
  
  def database_configuration(environment)
    environment ||= 'development'
    
    file = File.dirname(__FILE__) + '/config/database.yml'
    YAML.load_file(file)[environment]
  end
  
  def mysql_parameters(config)
    password = (config['password'].nil?) ? '' : "-p#{config['password']}"
    "-u#{config['username']} #{password} #{config['database']}"
  end
  
  desc "Create the database in the specified environment"
  task :create, :environment do |t, args|
    config = database_configuration(args[:environment])
    `mysqladmin create #{mysql_parameters(config)}`
  end
  
  desc "Drop the database in the specified environment"
  task :drop, :environment do |t, args|
    config = database_configuration(args[:environment])
    `mysqladmin drop -f #{mysql_parameters(config)}`
  end
  
  desc "Migrate the database"
  task :migrate, :environment do |t, args|
    require 'activerecord'
    
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.establish_connection(database_configuration(args[:environment]))
    
    ActiveRecord::Migrator.migrate("db/migrate/")
  end
  
  desc "Remigrate the database from scratch"
  task :remigrate, :environment do |t, args|
    %w(drop create migrate).each do |name|
      Rake::Task["db:#{name}"].invoke(args[:environment])
    end
  end
  
end