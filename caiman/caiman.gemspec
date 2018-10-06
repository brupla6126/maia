lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caiman/version'

Gem::Specification.new do |spec|
  spec.name          = 'caiman'
  spec.version       = Caiman::VERSION
  spec.authors       = ['Bruno Plamondon']
  spec.email         = ['bplamondon66@gmail.com']

  spec.summary       = 'Business logic following Clean Architecture principals.'
  spec.description   = 'Business logic following Clean Architecture principals.'
  spec.homepage      = 'https://github.com/brupla6126/maia/caiman'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'araignee', '~> 0.1'
end
