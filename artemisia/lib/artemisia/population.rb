require_relative 'definition'
require_relative 'world/factory'

world_path = File.expand_path('world', __dir__)
Dir.glob("#{world_path}/**/*.rb") { |file| require file }

template_path = File.expand_path('templates', __dir__)

paths = [template_path]
puts "paths: #{paths}"

store = {}
factory = World::Factory.new(store, paths)
factory.load_definitions

puts "\nstore: #{store}\n\n"

frog1 = factory.entity(:split_frog)
frog2 = factory.entity(:split_frog)

puts "frog1: #{frog1.inspect}"
puts "frog2: #{frog2.inspect}"

frog3 = factory.entity(:speed_frog)
puts "frog3: #{frog3.inspect}"

gravity = factory.system(:gravity)
puts "gravity: #{gravity.inspect}"
