require "yaml"
require "erb"

module Econfig
  class YAML
    def initialize(path)
      @path = path
      @mutex = Mutex.new
      @options = nil
    end

    def get(key)
      options[key]
    end

    def has_key?(key)
      options.has_key?(key)
    end

  private

    def path
      raise Econfig::UninitializedError, "Econfig.root is not set" unless Econfig.root
      File.expand_path(@path, Econfig.root)
    end

    def options
      return @options if @options

      @mutex.synchronize do
        @options ||= if File.exist?(path)
          ::YAML.load(::ERB.new(File.read(path)).result)[Econfig.env]
        else
          {}
        end
      end
    end
  end
end
