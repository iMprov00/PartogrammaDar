require './config/environment'
require 'sinatra/activerecord/rake'

namespace :db do
  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/partogram.db')
    puts "Database created successfully!"
  end

  desc "Run migrations"
  task :migrate do
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    puts "Migrations completed successfully!"
  end

  desc "Create a new migration"
  task :create_migration, [:name] do |t, args|
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    filename = "db/migrate/#{timestamp}_#{args[:name]}.rb"
    
    File.open(filename, 'w') do |f|
      f.write <<~RUBY
        class #{args[:name].split('_').map(&:capitalize).join} < ActiveRecord::Migration[6.1]
          def change
          end
        end
      RUBY
    end
    
    puts "Created migration: #{filename}"
  end
end

desc "Start the application"
task :start do
  exec 'bundle exec ruby app.rb'
end

desc "Open console"
task :console do
  exec 'bundle exec irb -r ./app'
end