ruby '2.4.2'

source 'https://rubygems.org'

group :development do
  gem 'mutant-rspec', '~> 0.8', require: false
  gem 'rubocop', '~> 0.59', require: false
  gem 'rubycritic', '~> 3.4', require: false
end

group :test do
  gem 'simplecov', '~> 0.16', require: false
  gem 'state_machines-rspec', '~> 0.5', require: false
end

group :development, :test do
  gem 'pry-byebug', '~> 3.6', require: false
  gem 'rspec', '~> 3.6', require: false
  gem 'rspec-mocks', '~> 3.6', require: false
  gem 'timecop', '~> 0.9', require: false
end

# Specify your gem's dependencies in araignee.gemspec
gemspec
