# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "capistrano3-delayed-job"
  spec.version       = "1.7.0"
  spec.authors       = ["Juan Ignacio Donoso", "Agustin Feuerhake", "Ignacio Baixas"]
  spec.email         = ["juan.ignacio@platan.us", "agustin@platan.us", "ignacio@platanus"]
  spec.summary       = %q{Adds support for delayed_jobs to Capistrano 3.x}
  spec.description   = %q{Adds support for delayed_jobs to Capistrano 3.x}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '>= 3.0.0'

  spec.add_development_dependency "rake", "~> 10.0"
end
