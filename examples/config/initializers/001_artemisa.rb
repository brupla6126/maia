require 'artemisia'

Artemisia.setup do |config|
  puts "initializers path: #{config.initializers_path}"
  puts "factories paths: #{config.factories_paths}"
end
