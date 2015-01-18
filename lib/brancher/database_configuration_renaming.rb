module Brancher
  module DatabaseConfigurationRenaming
    def database_configuration
      configurations = super
      DatabaseRenameService.rename!(configurations)
      configurations
    end
  end
end