require 'json'
##
# The Filesystem Persister is a cheap-and cheerful means of maintaining
# persistence of a given model in the filesystem as json files.
#
# Usage:
# Include FilesystemPersiter::Persisted in any classes that require persistence
# Optionally use persisted_in to define the name of a subdirectory for the class
# By default, the persister looks in a downcased classname
#
# Configuration:
# By default, the persister looks in the ./store directory in the root of the
# application. You can use:
# FilesystemPersister::Config.directory='your_directory'
#
# This is not intended for cases where there will be more than a handful of
# records
module FilesystemPersister

  DEFAULT_STORE = './store'
  FILENAME_FORMAT = /^[[:alnum:]_]+$/

  class ConfigError < StandardError; end

  ##
  # Raised to indicate that someone has attempted to use an invalid filename
  class InvalidNameError < StandardError; end

end
