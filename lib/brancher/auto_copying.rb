module Brancher
  module AutoCopying
    def new_connection
      done = false

      begin
        super
      rescue
        raise if done
        raise unless Brancher.config.auto_copy

        executor = Executor.new(spec.config)
        executor.auto_copy
        done = true
        retry
      end
    end

    class Executor
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def auto_copy
        return if config[:database] == config[:original_database]

        database_name = config[:database]
        original_database_name = config[:original_database]

        case config[:adapter]
        when /mysql/
          mysql_copy(original_database_name, database_name)
        when /postgresql/
          pg_copy(original_database_name, database_name)
        end
      end

      def mysql_copy(original_database_name, database_name)
        ActiveRecord::Tasks::DatabaseTasks.create(config.with_indifferent_access)

        cmd = ["mysqldump", "-u", config[:username]]
        cmd.concat(["-h", config[:host]]) if config[:host].present?
        cmd.concat(["-p#{config[:password]}"]) if config[:password].present?
        cmd << original_database_name
        cmd.concat(["|", "mysql", "-u", config[:username]])
        cmd.concat(["-h", config[:host]]) if config[:host].present?
        cmd.concat(["-p#{config[:password]}"]) if config[:password].present?
        cmd << database_name
        system(cmd.join(" "))
      end

      def pg_copy(original_database_name, database_name)
        env = {}
        env["PGUSER"] = config[:username] if config[:username].present?
        env["PGPASSWORD"] = config[:password] if config[:password].present?
        env["PGHOST"] = config[:host] if config[:host].present?

        system(env, "createdb", "-T", original_database_name, database_name)
      end
    end
  end
end
