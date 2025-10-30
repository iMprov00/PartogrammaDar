require 'bundler/setup'
Bundler.require

configure :development do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

configure do
  set :public_folder, 'public'
  set :views, 'views'
  
  db_config = YAML.load(File.read('config/database.yml'))
  ActiveRecord::Base.establish_connection(db_config['development'])
end

require_all 'models'