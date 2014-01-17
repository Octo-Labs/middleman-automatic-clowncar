# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-automatic-clowncar/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-automatic-clowncar"
  spec.version       = MiddlemanAutomaticClowncar::VERSION
  spec.authors       = ["Jeremy Green"]
  spec.email         = ["jeremy@octolabs.com"]
  spec.summary       = %q{Automatically generated responsive images for middleman.}
  spec.description   = %q{Automatically generated responsive images for middleman.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
