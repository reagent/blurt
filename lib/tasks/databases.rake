namespace :db do
  
  desc "Remigrate database from scratch"
  task :remigrate => %w(db:drop db:create db:migrate)
  
end