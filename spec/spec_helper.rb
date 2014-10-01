require 'rspec'
require 'ffaker'
require "active_support"
require "active_support/core_ext"
require "active_record"

Root =  Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

require File.join Root, "lib", "commerce_units"
require File.join(Root, "spec", "factories", "base_factory")
Dir[File.join(Root, "spec", "factories", "**", "*.rb")].each { |f| require f }
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

require File.join Root, "spec", "fixtures", "migration"
CreateCommerceUnitsDimensions.migrate :up