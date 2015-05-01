##
# Singleton class to contain the configuration options
module FilesystemPersister
  class Config
    ##
    # The configuration options for the persister
    OPTIONS = [:directory]

    class << self

      ##
      # Yields the configuration object to a block, allowing the config to be set
      # Options are:
      # directory: the base directory for persisted files
      def configure
        yield new
        @singleton
      end

      def new(*args)
        @singleton ||= super(*args)
      end

      alias :singleton :new

      OPTIONS.each do |attribute|
        define_method(attribute) { Config.singleton.send(attribute) }
        define_method(attribute.to_s+'=') {|*args| Config.singleton.send(attribute.to_s+'=',*args) }
      end

    end

    attr_accessor *OPTIONS

    private

    def initialize(directory:DEFAULT_STORE)
      @directory = directory
    end
  end
end
