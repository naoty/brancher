require "active_record"

module Brancher
  module DatabaseRenameService
    extend self

    def rename!(configurations)
      configuration = configurations[env]
      configuration["original_database"] = configuration["database"]
      configuration["database"] = database_name_with_suffix(configuration["database"])
      configurations
    end

    private

    def database_name_with_suffix(database)
      database_extname = File.extname(database)
      database_name = database.gsub(%r{#{database_extname}$}) { "" }
      database_name += suffix unless database_name =~ %r{#{suffix}$}
      database_name += database_extname
      database_name = database_name.slice(0,Brancher.config.max_database_name_length-22) + [Digest::MD5.digest(database_name)].pack("m0").slice(0,22).gsub(/[^\w]/, '_').downcase if database_name.length > Brancher.config.max_database_name_length
      database_name
    end

    def suffix
      return nil if current_branch.blank? || Brancher.config.except_branches.include?(current_branch)
      "_#{current_branch}"
    end

    def env
      Rails.env
    end

    def current_branch
      @current_branch ||= `git rev-parse --abbrev-ref HEAD`.chomp
    end
  end
end
