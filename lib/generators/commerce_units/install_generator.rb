require 'rails/generators/migration'
module CommerceUnits
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      desc "Create a migration for the dimensional storage"

      source_root File.expand_path('../templates/migrations', __FILE__)

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
  end
end