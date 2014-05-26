module Econfig
  class YAML
    def initialize(path)
      @path = path
    end

    def get(key)
      options[key]
    end

    def init
      require "yaml"
      require "erb"
      if File.exist?(path)
        @options = ::YAML.load(::ERB.new(File.read(path)).result)[Econfig.env]
      else
        @options = {}
      end
    end

  private

    def path
      File.expand_path(@path, Econfig.root)
    end

    def options
      @options or raise Econfig::UninitializedError
    end
  end
end
