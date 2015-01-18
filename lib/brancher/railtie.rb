require "rails"

module Brancher
  class Railtie < Rails::Railtie
    initializer "brancher.rename_database", before: "active_record.initialize_database" do
      Rails::Application::Configuration.send(:prepend, DatabaseConfigurationRenaming)
    end

    rake_tasks do
      namespace :db do
        task :load_config do
          DatabaseRenameService.rename!(ActiveRecord::Base.configurations)
        end
      end
    end
  end
end