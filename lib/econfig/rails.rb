require "rails"
require "econfig"

module Econfig
  class Railtie < Rails::Railtie
    initializer "econfig.setup" do
      Econfig.root = Rails.root
      Econfig.env = Rails.env
      Rails.application.config.app = Econfig.instance

      Econfig.instance.backends.each do |backend|
        backend.eager_load! if backend.respond_to?(:eager_load!)
      end
    end
  end
end
