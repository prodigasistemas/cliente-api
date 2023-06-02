# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cliente_api/version'

Gem::Specification.new do |spec|
  spec.name          = "cliente-api"
  spec.version       = ClienteAPI::VERSION
  spec.author        = "Pródiga Sistemas"
  spec.email         = "contato@prodigasistemas.com.br"

  spec.summary       = "Wrapper da API"
  spec.description   = "Facilita a contrução de objetos dos JSON retornados pela API"
  spec.homepage      = "https://gitlab.cosanpa.pa.gov.br"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency "rest-client"
  spec.add_dependency "kaminari"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
