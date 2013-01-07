module Econfig
  class YAML
    def initialize(path="config/app.yml")
      @path = path
    end

    def get(key)
      options[key] if options
    end

  private

    def path
      File.expand_path(@path, Econfig.root)
    end

    def options
      @options ||= ::YAML.load_file(path)[Econfig.env] if File.exist?(path)
    end
  end
end
