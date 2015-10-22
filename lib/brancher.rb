$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require 'active_support/configurable'

module Brancher
  include ActiveSupport::Configurable
  config.except_branches ||= []
  config.auto_copy ||= false
  config.max_database_name_length ||= 63
end

require "brancher/database_configuration_renaming"
require "brancher/multiple_database_configuration_renaming"
require "brancher/database_rename_service"
require "brancher/auto_copying"
require "brancher/railtie"
require "brancher/version"
