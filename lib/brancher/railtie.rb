require "rails"

module Brancher
  class Railtie < Rails::Railtie
    rake_tasks do
      namespace :db do
        task :load_config do
          current_branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
          DatabaseTasks.rename_database(current_branch_name)
        end
      end
    end
  end
end