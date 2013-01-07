require "rails"
require "econfig"

module Econfig
  class Railtie < Rails::Railtie
    initializer "econfig.setup" do
      Econfig.root = Rails.root
      Econfig.env = Rails.env
      Rails.application.config.app = Econfig.instance
    end
  end
end
