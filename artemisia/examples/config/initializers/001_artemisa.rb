require 'artemisia'

Artemisia.setup do |config|
  puts "initializers paths #{config.initializer_paths}"
  puts "factory paths: #{config.factory_paths}"
end
