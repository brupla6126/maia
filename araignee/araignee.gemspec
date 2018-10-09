lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'araignee/version'

Gem::Specification.new do |spec|
  spec.name          = 'araignee'
  spec.version       = Araignee::VERSION
  spec.authors       = ['Bruno Plamondon']
  spec.email         = ['bplamondon66@gmail.com']

  spec.summary       = 'Araignee Library'
  spec.description   = 'Araignee Library: Core classes for creating great Ruby apps.'
  spec.homepage      = 'https://github.com/brupla6126/maia/araignee'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'hooks', '~> 0.4'
  spec.add_dependency 'logger', '~> 1.2'
  spec.add_dependency 'state_machines', '~> 0.5'
  spec.add_dependency 'virtus', '~> 1.0'
end
