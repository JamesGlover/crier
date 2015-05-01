require './lib/filesystem_persister'
require './lib/filesystem_persister/config'

module FilesystemPersister
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

      def persisted_attributes
        @persisted_attributes ||= [:name]
      end

      private

      attr_writer :persisted_attributes

      def valid_filename?(filename)
        return false unless FILENAME_FORMAT === filename
        return false unless File.exist?("#{model_dir}/#{filename}")
        true
      end

      def persisted_in(directory)
        @sub_dir = directory
      end

      def persist_as_json(*attributes)
        self.persisted_attributes += attributes
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

    ##
    # Saves the record in the appropriate model directory
    # returns false in the event the model fails validation, or has an invalid name
    def save
      return false unless valid?
      attributes = to_hash
      name = attributes.delete('name')
      begin
        File.open(filename,'w+') do |f|
          f << attributes.to_json
        end
      rescue InvalidNameError => e
        # The name provided is not a valid filename.
        add_error(e.message)
        return false
      end
      true
    end

    ##
    # By default no validation is performed
    def valid?
      true
    end

    ##
    # Deletes the associated record. This method is idempotent so
    # can be called multiple times without issue.
    # Similarly if you have a record with an invalid name, this method
    # will not complain.
    def delete
      begin
        File.delete(filename) if File.exist?(filename)
      rescue InvalidNameError => e
        # If we have an invalid name at this stage we probably don't care
        # we just rescue the exception
      end
      true
    end

    ##
    # Returns the record as serialized json
    def to_json(*args)
      to_hash.to_json(*args)
    end

    ##
    # Represent the record as a hash
    def to_hash
      Hash[self.class.persisted_attributes.map {|v| [v,instance_variable_get("@#{v}")]}]
    end

    ##
    # The returned name MUST match a valid format
    def name
      filtered_name = FILENAME_FORMAT.match(@name)
      return filtered_name.string unless filtered_name.nil?
    end

    def errors
      @errors ||= []
    end

    def update(hash)
      (self.class.persisted_attributes - [:name]).each do |attribute|
        if hash[attribute]||hash[attribute.to_s]
          instance_variable_set("@#{attribute}",hash[attribute]||hash[attribute.to_s])
        end
      end
      self
    end

    private

    attr_writer :name

    def initialize(hash)
      self.class.persisted_attributes.each do |attribute|
        if hash[attribute]||hash[attribute.to_s]
          instance_variable_set("@#{attribute}",hash[attribute]||hash[attribute.to_s])
        end
      end
    end

    def filename
      raise ConfigError, "Model directory is nor defined for #{self.class.name}" if self.class.send(:model_dir).nil?
      raise InvalidNameError, 'Name can only contain letters, numbers and underscores.' if name.nil?
      "#{self.class.send(:model_dir)}/#{name}"
    end

    def add_error(new_error)
      errors << new_error unless errors.include?(new_error)
    end
  end
end
