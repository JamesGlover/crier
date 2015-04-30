require 'json'
##
# The Filesystem Persister is a cheap-and cheerful means of maintaining
# persistence of a given model in the filesystem as json files.
#
# Usage:
# Include FilesystemPersiter::Persisted in any classes that require persistence
# Optionally use persisted_in to define the name of a subdirectory for the class
# By default, the persister looks in a downcased classname
#
# Configuration:
# By default, the persister looks in the ./store directory in the root of the
# application. You can use:
# FilesystemPersister::Config.directory='your_directory'
#
# This is not intended for cases where there will be more than a handful of
# records
module FilesystemPersister

  DEFAULT_STORE = './store'

  class Config

    class << self

      ##
      # Yields the configuration object to a block, allowing the config to be set
      # Options are:
      # directory: the base directory for persisted files
      def configure
        yield new
        @singleton
      end

      private

      def method_missing(*args)
        new.send(*args)
      end

      def new(*args)
        @singleton ||= super(*args)
      end

    end

    attr_accessor :directory

    private

    def initialize(directory:DEFAULT_STORE)
      @directory = directory
    end

  end

  module Persisted

    module ClassMethods
      ##
      # Retrieves the record identified by the given name
      def find(name)
        return nil unless valid_filename?(name)
        fetch("#{model_dir}/#{name}")
      end

      ##
      # Returns and array of all records
      # Caution! All records will be immediately instantiated
      def all(*args)
        all_filenames.map do |filename|
          fetch(filename)
        end
      end

      private

      def valid_filename?(filename)
        return false unless /^[[:alnum:]_]+$/ === filename
        return false unless File.exist?("#{model_dir}/#{filename}")
        true
      end

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
        attributes = JSON.load(file)
        new(attributes.merge(name:name))
      end
    end

    def self.included(base)
      base.class_eval { extend ClassMethods }
    end

    def save
      attributes = to_hash
      name = attributes.delete('name')
      File.open(filename,'w+') do |f|
        f << attributes.to_json
      end
      true
    end

    def delete
      File.delete(filename) if File.exist?(filename)
      true
    end

    def to_json(*args)
      to_hash.to_json(*args)
    end

    def to_hash
      Hash[instance_variables.map {|v| [v.to_s.gsub('@',''),instance_variable_get(v)]}]
    end

    private

    def initialize(hash)
      hash.each do |key,value|
        instance_variable_set("@#{key}",value)
      end
    end

    def filename
      raise StandardError if self.class.send(:model_dir).nil? || name.nil?
      "#{self.class.send(:model_dir)}/#{name}"
    end
  end
end
