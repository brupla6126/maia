# ruby '2.3.1'

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development do
  gem 'rubocop', '0.58.1', require: false
  gem 'rubycritic', '3.4.0', require: false
end

group :test do
  gem 'simplecov', '0.16.1', require: false
end

group :development, :test do
  gem 'pry-byebug', '3.6.0'
end

# Specify your gem's dependencies in artemisia.gemspec
gemspec
