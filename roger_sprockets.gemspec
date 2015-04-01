# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roger_sprockets/version"

Gem::Specification.new do |spec|
  spec.name          = "roger_sprockets"
  spec.version       = RogerSprockets::VERSION
  spec.authors       = ["Edwin van der Graaf"]
  spec.email         = ["edwin@digitpaint.nl"]
  spec.summary       = "Add sprockets to your roger project"
  spec.homepage      = "https://github.com/digitpaint/roger_sprockets"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sprockets"
  spec.add_dependency "sprockets-es6"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", [">= 0"]
  spec.add_development_dependency "rubocop", ["~> 0"]
end
