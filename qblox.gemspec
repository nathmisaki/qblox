# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qblox/version'

Gem::Specification.new do |spec|
  spec.name          = 'qblox'
  spec.version       = Qblox::VERSION
  spec.authors       = ['Nelson Haraguchi']
  spec.email         = ['nelsonmhjr@gmail.com']

  spec.summary       = 'Gem to use Quickblox REST API'
  spec.description   = 'This gem is still under development. '\
                       'Consider this before using it in production'
  spec.homepage      = 'https://github.com/nelsonmhjr/qbox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'redis', '>= 2.2.2'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock', '~> 2.0'
end
