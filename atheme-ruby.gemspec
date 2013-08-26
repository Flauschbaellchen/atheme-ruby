# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atheme/version'

Gem::Specification.new do |spec|
  spec.name = "atheme-ruby"
  spec.homepage = "http://github.com/Flauschbaellchen/atheme-ruby"
  spec.license = "MIT"
  spec.summary = %Q{Atheme-XMLRPC interface for Ruby}
  spec.description = %Q{Provides a ruby interface for atheme's XMPRPC API}
  spec.email = "noxx@penya.de"
  spec.authors = ["Noxx"]
  spec.version = Atheme::Version

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
