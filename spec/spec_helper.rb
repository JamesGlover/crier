require './lib/filesystem_persister'

FilesystemPersister::Config.configure do |c|

  c.directory = './spec/test_store'

end
