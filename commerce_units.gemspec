# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'commerce_units/version'

Gem::Specification.new do |spec|
  spec.name          = "commerce_units"
  spec.version       = CommerceUnits::VERSION
  spec.authors       = ["Thomas Chen"]
  spec.email         = ["foxnewsnetwork@gmail.com"]
  spec.summary       = %q{Another ruby units library for doing dimensional math, this one to be used with rails, preferrably commerce-related apps}
  spec.description   = %q{Another ruby units library for doing dimensional math, this one to be used with rails, preferrably commerce-related apps}}
  spec.homepage      = "http://github.com/foxnewsnetwork/commerce_units"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "ffaker"

  spec.add_dependency('activemodel', '>= 3.0.0')
  spec.add_dependency('activerecord', '>= 3.0.0')
  spec.add_dependency('activesupport', '>= 3.0.0')
  spec.add_dependency "functional_support", '>= 0.0.6'

end
