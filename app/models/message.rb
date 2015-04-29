require './lib/filesystem_persister'

class Message

  include FilesystemPersister::Persisted

  attr_reader :type, :body, :name

  def date
    Time.new(@date)
  end

  def title
    name.gsub('_',' ').capitalize
  end

end
