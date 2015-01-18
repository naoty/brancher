require "active_record"

module Brancher
  module DatabaseRenameService
    extend self

    def rename!(configurations)
      configuration = configurations[env]
      database_extname = File.extname(configuration["database"])
      database_name = configuration["database"].gsub(%r{#{database_extname}$}) { "" }
      database_name += "_#{current_branch}"
      configuration["database"] = database_name + database_extname
      configurations.merge!(env => configuration)
    end

    private

    def env
      Rails.env
    end

    def current_branch
      @current_branch ||= `git rev-parse --abbrev-ref HEAD`.chomp
    end
  end
end