# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'document_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "document_builder"
  spec.version       = DocumentBuilder::VERSION
  spec.authors       = ["Patrick Schmitz"]
  spec.email         = ["p.schmitz@gmail.com"]
  spec.summary       = %q{A document builder for nokogiri documents.}
  spec.description   = %q{This is a small set of modules for building up xpath based document attributes from a nokogir document object.}
  spec.homepage      = "https://github.com/bullfight/document_builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "nokogiri", "~> 1.6.6"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "pry"
end
