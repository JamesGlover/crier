##
# You may wish to update this configuration file when deploying to production
# All configuration options also provide ENV alternatives

# The directory in which messages will be stored. Should be read-writable by the application
# Or specify with the ENV CRIER_PERSISTER_DIRECTORY
FilesystemPersister::Config.directory = ENV['CRIER_PERSISTER_DIRECTORY'] || './store'
