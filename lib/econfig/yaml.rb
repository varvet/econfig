module Econfig
  class YAML
    def initialize(path="config/app.yml")
      @path = path
    end

    def get(key)
      options[key]
    end

    def init
      require "yaml"
      if File.exist?(path)
        @options = ::YAML.load_file(path)[Econfig.env]
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
