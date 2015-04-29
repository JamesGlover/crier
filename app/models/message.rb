require './lib/filesystem_persister'

class Message

  include FilesystemPersister::Persisted

  attr_reader :name
  attr_accessor :types, :body

  def date
    Time.new(@date) if @date
  end

  def date=(new_date)
    @date = new_date.to_s
  end

  def title
    name.gsub('_',' ').capitalize
  end

  def initialize(*args)
    super
    self.date = Time.now unless date
  end

  def classes
    types.join(' ')
  end

end
