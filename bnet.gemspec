# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bnet/version'

Gem::Specification.new do |spec|
  spec.name          = "bnet"
  spec.version       = Bnet::VERSION
  spec.authors       = ["Buddy Magsipoc"]
  spec.email         = ["keikun17@gmail.com"]
  spec.summary       = "Ruby gem for accessing Blizzard's Mashery API"
  spec.description   = "This repository (will) contain various libraries for interfacing with takes a deep breath Blizzard's-Battle.net-Mashery- API."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "coveralls"
end
