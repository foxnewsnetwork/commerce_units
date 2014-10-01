require 'rails/generators/migration'
module CommerceUnits
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      desc "Create a migration for the dimensional storage"

      source_root File.expand_path('../templates/migrations', __FILE__)

      # Define the next_migration_number method (necessary for the migration_template method to work)
      # Stolen shamelessly from socery gem's generators
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          sleep 1 # make sure each time we get a different timestamp
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
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
  end
end