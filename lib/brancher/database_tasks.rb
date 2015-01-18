require "active_record"

module Brancher
  module DatabaseTasks
    extend self

    def rename_database(branch_name)
      database_extname = File.extname(current_configuration["database"])
      database_name = current_configuration["database"].gsub(%r{#{database_extname}$}) { "" }
      database_name += "_#{branch_name}"
      current_configuration["database"] = database_name + database_extname
    end

    private

    def current_configuration
      ActiveRecord::Base.configurations[Rails.env]
    end
  end
end