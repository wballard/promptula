# -*- encoding: utf-8 -*-
require File.expand_path('../lib/promptula/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Will Ballard"]
  gem.email         = ["wballard@mailframe.net"]
  gem.description   = 'Handy shell prompt extension for your BASH'
  gem.summary       = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "promptula"
  gem.require_paths = ["lib"]
  gem.version       = Promptula::VERSION

  gem.add_dependency 'rainbow'
  gem.add_dependency 'trollop'
  gem.add_development_dependency 'bundler'
end
