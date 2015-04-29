require './lib/filesystem_persister'

class Message

  include FilesystemPersister::Persisted

  attr_reader :name, :type, :body

  def date
    Time.new(@date)
  end

end
