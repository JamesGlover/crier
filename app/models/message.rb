require './lib/filesystem_persister/persisted'
require 'chronic_duration'

class Message

  CSS_CLASS_PREFIX = 'panel-'

  include FilesystemPersister::Persisted

  persist_as_json :types, :body, :date

  attr_accessor :body
  attr_writer :types

  class << self

    def message_level(level,time)
      @warning_levels << [level,ChronicDuration.parse(time.to_s,:keep_zero=>true)]
      @warning_levels.sort! {|a,b| b.first <=> a.first }
    end

    def warning_levels
      @warning_levels ||= [[0,'success']]
    end

    def warning_for(age)
      warning_levels.each do |time,state|
        return state if age >= time
      end
    end

  end

  def valid?
    super && (types.is_a?(Array) || add_error('Types must be an array'))
  end

  def types
    @types||[]
  end

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

  def age_warning
    self.class.warning_for(age_in_seconds)
  end

  ##
  # Age in whole number of seconds. Negative values are shown as zero
  def age_in_seconds
    [(Time.now-date).floor,0].max
  end

  ##
  # The age of the message in a friendly format eg. 3 weeks, 2 days
  def age
    ChronicDuration.output((Time.now-date).floor, :format=>:long, :weeks=>true, :units=>2)||"Less than a second"
  end

end
