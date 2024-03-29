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

  spec.add_dependency "middleman-core", "> 4.3.0"

  spec.add_dependency("mini_magick", ["~> 4.0"])
  spec.add_dependency "fastimage", "~> 2.0"

  # These are here to make sure that we don't have any collisions with sprockets
  spec.add_dependency "middleman-sprockets", "~> 4.1.0"
  #spec.add_dependency "sass", "~> 3.4.0"

  spec.add_development_dependency "middleman", "~> 4.4.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "capybara", "~> 2.5.0"
  spec.add_development_dependency "cucumber", "~> 6.0"
  spec.add_development_dependency "aruba",    "~> 0.14.0"
  spec.add_development_dependency "byebug"
  #spec.add_development_dependency "simplecov", "~> 0.8.2"
end
