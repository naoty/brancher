$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require "brancher/database_configuration_renaming"
require "brancher/database_rename_service"
require "brancher/railtie"
require "brancher/version"