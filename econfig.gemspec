# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'econfig/version'

Gem::Specification.new do |gem|
  gem.name          = "econfig"
  gem.version       = Econfig::VERSION
  gem.authors       = ["Jonas Nicklas", "Elabs AB"]
  gem.email         = ["jonas.nicklas@gmail.com", "dev@elabs.se"]
  gem.description   = %q{Flexible configuration for Ruby/Rails applications with a variety of backends}
  gem.summary       = %q{Congifure Ruby apps}
  gem.homepage      = "https://github.com/elabs/econfig"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "activerecord"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "redis"
end
