require 'hashie'
require 'json'
require_relative 'entity'

module World
  class Factory
    def initialize(store, paths)
      @store = store
      @paths = paths
    end

    def load_definitions
      @paths.each do |path|
        Dir.glob("#{path}/**/*") do |file|
          next unless File.file?(file)

          json = File.read(file)

          if file =~ /entity/
            load_entity(json)
          elsif file =~ /component/
            load_component(json)
          elsif file =~ /system/
            load_system(json)
          end
        end
      end
    end

    def entity(entity_type)
      World::Entity.new(components(entity_type))
    end

    def system(system_type)
      definition = system_definition(system_type)
      #      Hashie.symbolize_keys!(attribs)
      puts "definition.klass: #{definition.klass}"
      Object.const_get(definition.klass).new(definition.selection, definition.classes)

      #     World::System.new(definition.selection, definition.classes)
    end

    private

    def load_entity(json)
      entity = Definition::Entity.new
      entity_definition = Definition::EntityRepresenter.new(entity).from_json(json)
      puts "entity_definition: #{entity_definition}"
      @store[entity_definition.id.to_sym] = entity_definition
    end

    def load_component(json)
      component = Definition::Component.new
      component_definition = Definition::ComponentRepresenter.new(component).from_json(json)
      puts "component_definition: #{component_definition}"
      @store[component_definition.id.to_sym] = component_definition
    end

    def load_system(json)
      system = Definition::System.new
      system_definition = Definition::SystemRepresenter.new(system).from_json(json)
      puts "system_definition: #{system_definition}"
      @store[system_definition.id.to_sym] = system_definition
    end

    def entity_definition(type)
      @store[type]
    end

    def component_definition(type)
      @store[type]
    end

    def system_definition(type)
      @store[type]
    end

    def components(entity_type)
      entity_definition(entity_type).components.map do |component_type|
        cd = component_definition(component_type.to_sym)

        component(cd.klass, cd.attributes)
      end
    end

    def component(klass, attributes)
      attribs = attributes.dup
      Hashie.symbolize_keys!(attribs)

      Object.const_get(klass).new(attribs)
    end
  end
end
