require "rails/generators/active_record"
class CommerceUnitsGenerator < ActiveRecord::Generators::Base
  desc "Create a migration for the dimensional storage"

  def self.source_root
    @source_root ||= File.expand_path('../../db/migrations', __FILE__)
  end

  def generate_migration
    migration_template "create_commerce_units_dimensions.rb.erb", "db/migrate/#{migration_file_name}"
  end

  def migration_name
    "create_commerce_units_dimensions"
  end

  def migration_file_name
    "#{migration_name}.rb"
  end

  def migration_class_name
    migration_name.camelize
  end
end