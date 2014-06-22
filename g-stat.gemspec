# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g_stat/version'

Gem::Specification.new do |s|
  s.name           = 'g-stat'
  s.version        = GStat::VERSION
  s.platform       = Gem::Platform::RUBY
  s.date           = '2014-06-21'
  s.summary        = 'Useful GitHub Statistics'
  s.description    = 'Useful GitHub Statistics'
  s.authors        = ['Roque Pinel']
  s.homepage       = 'https://github.com/repinel/g-stat'
  s.license        = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'

  s.add_dependency 'json', '~> 1.8'
end