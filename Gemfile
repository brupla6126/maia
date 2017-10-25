# ruby '2.3.1'

source 'https://rubygems.org' do
  group :development, :test do
    gem 'parallel_tests'
    gem 'pry-byebug', '~> 3.5'
    gem 'rspec'
    gem 'rspec-mocks'
    gem 'timecop'
  end

  group :development do
    gem 'flay'
    gem 'flog'
    gem 'listen', '~> 3.0'
    gem 'guard', '~> 2.14'
    gem 'guard-rubocop', '~> 1.2'
    gem 'guard-rspec', '~> 4.7'
    gem 'mutant-rspec'
    gem 'rack-test'
    gem 'rack-contrib'
    gem 'rubocop'
    gem 'yard'
  end

  group :test do
    gem 'simplecov'
    gem 'state_machines-rspec'
  end
end

# Specify your gem's dependencies in araignee.gemspec
gemspec
