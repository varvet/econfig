require "forwardable"
require "econfig/version"
require "econfig/memory"
require "econfig/yaml"
require "econfig/env"
require "econfig/configuration"
require "econfig/shortcut"
require "econfig/backend_collection"

module Econfig
  class NotFound < StandardError; end
  class UninitializedError < StandardError; end

  class << self
    extend Forwardable

    attr_accessor :root, :env, :instance

    def_delegators :instance, :backends, :default_write_backend, :default_write_backend=
  end
end

Econfig.instance = Econfig::Configuration.new

Econfig.default_write_backend = :memory
Econfig.backends.use :memory, Econfig::Memory.new
Econfig.backends.use :env, Econfig::ENV.new
Econfig.backends.use :secrets, Econfig::YAML.new("config/secrets.yml")
Econfig.backends.use :yaml, Econfig::YAML.new("config/app.yml")
