# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g_stat/version'

Gem::Specification.new do |s|
  s.name           = 'g-stat'
  s.version        =  GStat::VERSION
  s.date           = '2014-06-21'
  s.summary        = 'Useful GitHub Statistics '
  s.description    = 'Useful GitHub Statistics '
  s.authors        = ['Roque Pinel']
  s.homepage       = 'https://github.com/repinel/g-stat'
  s.license        = 'MIT'

  s.files          = `git ls-files`.split($/)
  s.executables    = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths  = ['lib']

  s.add_dependency = 'json'
end