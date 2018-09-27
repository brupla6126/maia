ruby '2.4.1'

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'araignee', git: 'git@github.com:brupla6126/araignee', branch: 'master'

group :development do
  gem 'mutant-rspec', '~> 0.8', require: false
  gem 'rubocop', '~> 0.59', require: false
  gem 'rubycritic', '~> 3.4', require: false
end

group :test do
  gem 'simplecov', '~> 0.16', require: false
end

group :development, :test do
  gem 'pry-byebug', '~> 3.6'
  gem 'rspec', '~> 3.6'
  gem 'rspec-mocks', '~> 3.6'
end

# Specify your gem's dependencies in caiman.gemspec
gemspec
