module Econfig
  class YAML
    def initialize(path="config/app.yml")
      @path = path
    end

    def get(key)
      options[key] if options
    end

    def reload
      @options = options!
    end

    def name
      File.basename(@path, File.extname(@path))
    end

  private

    def path
      File.expand_path(@path, Econfig.root)
    end

    def options
      @options ||= options! if File.exist?(path)
    end

    def options!
      ::YAML.load_file(path)[Econfig.env]
    end
  end
end
