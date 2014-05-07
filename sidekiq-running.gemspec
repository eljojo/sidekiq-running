# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/running/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-running"
  spec.version       = Sidekiq::Running::VERSION
  spec.authors       = ["José Tomás Albornoz"]
  spec.email         = ["jojo@eljojo.net"]
  spec.summary       = %q{Sidekiq extension to check if you have a job queued or running}
  spec.description   = %q{Sidekiq extension to check if you have a job queued or running}
  spec.homepage      = "https://github.com/eljojo/sidekiq-running"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.2"
end
