$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require "brancher/database_tasks"
require "brancher/railtie"
require "brancher/version"