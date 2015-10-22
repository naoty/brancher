require "rails"

module Brancher
  class Railtie < Rails::Railtie
    initializer "brancher.rename_database", before: "active_record.initialize_database" do
      Rails::Application::Configuration.send(:prepend, DatabaseConfigurationRenaming)
      ActiveRecord::Base.send(:prepend, MultipleDatabaseConfigurationRenaming)
      ActiveRecord::ConnectionAdapters::ConnectionPool.send(:prepend, AutoCopying)
    end

    rake_tasks do
      namespace :db do
        task :load_config do
          require_environment!
          DatabaseRenameService.rename!(ActiveRecord::Base.configurations)
        end
      end
    end

    def require_environment!
      return unless defined? Rails
      environemnt = "#{Rails.root}/config/environments/#{Rails.env}.rb"
      require environemnt if File.exists?(environemnt)
    end
  end
end
