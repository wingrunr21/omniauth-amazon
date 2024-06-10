# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/amazon/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-amazon"
  spec.version       = OmniAuth::Amazon::VERSION
  spec.authors       = ["Stafford Brunk"]
  spec.email         = ["stafford.brunk@gmail.com"]
  spec.description   = %q{Login with Amazon OAuth2 strategy for OmniAuth 2.0}
  spec.summary       = %q{Login with Amazon OAuth2 strategy for OmniAuth 2.0}
  spec.homepage      = "https://github.com/wingrunr21/omniauth-amazon"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth-oauth2', '~> 1.7.1'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
