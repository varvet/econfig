require "econfig"

Econfig.root = File.dirname(__FILE__)
Econfig.env = "test"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:expect, :should]
  end
end
