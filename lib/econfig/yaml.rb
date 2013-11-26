module Econfig
  class YAML
    def initialize(path="config/app.yml")
      @path = path
    end

    def get(key)
      options[key] if options
    end

    # Make sure your application calls this method
    # during boot to ensure options are assigned in a
    # thread-safe maner. If you're using Rails requireing
    # econfig/rails in your Gemfile is sufficent.
    def eager_load!
      @options = ::YAML.load_file(path)[Econfig.env]
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
