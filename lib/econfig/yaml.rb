module Econfig
  class YAML
    def get(key)
      options[key]
    end

  private

    def options
      @options ||= ::YAML.load_file(File.join(Econfig.root, "config/app.yml"))[Econfig.env]
    end
  end
end
