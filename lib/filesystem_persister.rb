require 'json'
##
# The Filesystem Persister is a cheap-and cheerful means of maintaining
# persistence of a given model in the filesystem as json files.
#
# Usage:
# include FilesystemPersiter::Persisted in any classes
module FilesystemPersister

  DEFAULT_STORE = './store'

  class Config

    class << self

      def new(*args)
        @singleton ||= super(*args)
      end

      def configure
        yield new
        @singleton
      end

      def method_missing(*args)
        Config.new.send(*args)
      end

    end

    attr_accessor :directory

    def initialize(directory:DEFAULT_STORE)
    end

  end

  module Persisted

    module ClassMethods
      def find(name)
        return nil unless /^[[:alnum:]_]+$/ === name
        filename = "#{model_dir}/#{name}"
        return nil unless File.exist?(filename)
        fetch(filename)
      end

      def all(*args)
        all_filenames.map do |filename|
          fetch(filename)
        end
      end

      private

      def persisted_in(directory)
        @sub_dir = directory
      end

      def model_dir
        "#{Config.directory}/#{@sub_dir||self.name.downcase}"
      end

      def all_filenames
        Dir["#{model_dir}/*"]
      end

      def fetch(filename)
        File.open(filename) do |file|
          new_from_file(file)
        end
      end

      def new_from_file(file)
        name = File.basename(file.path)
        attributes = JSON.load file
        new(attributes.merge(name:name))
      end
    end

    def self.included(base)
      base.class_eval { extend ClassMethods }
    end

    def initialize(hash)
      hash.each do |key,value|
        instance_variable_set("@#{key}",value)
      end
    end
  end
end
