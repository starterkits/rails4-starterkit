# Monkey patch SchemaPlus to not use foreign keys in tests
if Rails.env.test?
  module SchemaPlus::ActiveRecord::ConnectionAdapters
    module TableDefinition
      def add_foreign_key(*args)
        puts '!!! FOREIGN KEYS DISABLED IN TESTS'
        puts '!!! See config/initializers/schema_plus.rb'
        self
      end
    end
  end
end
