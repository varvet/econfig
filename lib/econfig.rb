require "econfig/version"
require "econfig/memory"
require "econfig/yaml"
require "econfig/env"
require "econfig/configuration"
require "econfig/shortcut"

module Econfig
  class NotFound < StandardError; end

  class << self
    attr_accessor :root, :env, :instance
  end
end

Econfig.instance = Econfig::Configuration.new
Econfig.instance.backends << Econfig::ENV.new
Econfig.instance.backends << Econfig::YAML.new
