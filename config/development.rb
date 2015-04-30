##
# This is an example configuration file.
# It is typically not necessary to make changes to it
# for development purposes

FilesystemPersister::Config.directory = ENV['crier_persistor_directory'] || './store'
