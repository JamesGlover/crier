require './lib/filesystem_persister/persisted'

class Message

  CSS_CLASS_PREFIX = 'panel-'

  include FilesystemPersister::Persisted

  persist_as_json :types, :body, :date

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
    self.date ||= Time.now
  end

  def classes
    types.map {|t| CSS_CLASS_PREFIX + t }.join(' ')
  end

end
