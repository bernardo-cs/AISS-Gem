# coding: utf-8

#gem build aiss.gemspec
#gem install ./aiss-version.gem

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aiss/version'

Gem::Specification.new do |spec|
  spec.name          = "aiss"
  spec.version       = '1.1'
  spec.authors       = ["tufa"]
  spec.email         = ["bersimoes@gmail.com"]
  spec.description   = "Manda mails como a padeira de Aljubarrota"
  spec.summary       = "Aiss gem lets you send/receive emails sign with the Portuguese citizen card, the body can also be cyphered and zipped"
  spec.homepage      = "https://github.com/golfadas"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
