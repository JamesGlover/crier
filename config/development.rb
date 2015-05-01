##
# This is an example configuration file.
# It is typically not necessary to make changes to it
# for development purposes

FilesystemPersister::Config.directory = ENV['crier_persistor_directory'] || './store'

Message.message_level give_status:'default', after:'1 day'
Message.message_level give_status:'info',    after:'7 days'
Message.message_level give_status:'warning', after:'2 weeks'
Message.message_level give_status:'danger',  after:'4 weeks'
