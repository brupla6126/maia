require_relative 'definition'
require_relative 'generator'
require_relative 'shape_shifter'

world_path = File.expand_path('world', __dir__)
Dir.glob("#{world_path}/**/*.rb") { |file| require file }

factories_path = File.expand_path('factories', __dir__)
Dir.glob("#{factories_path}/**/*.rb") { |file| require file }

template_path = File.expand_path('templates', __dir__)

generator = Definition::Generator.new(template_path)

generator.clean

def representer(klass)
  case klass.to_s
  when 'Definition::Entity'
    Definition::EntityRepresenter
  when 'Definition::Component'
    Definition::ComponentRepresenter
  when 'Definition::System'
    Definition::SystemRepresenter
  else
    raise ArgumentError, "invalid class_name: #{klass}"
  end
end

ShapeShifter.classes.each_key do |id|
  instance = ShapeShifter.build(id)

  json = representer(instance.definition).new(instance).to_json

  parts = instance.definition.to_s.split('::')
  path = parts.last.downcase

  generator.write(path, "#{id}.json", json)
end
