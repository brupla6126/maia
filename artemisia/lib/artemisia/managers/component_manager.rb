require 'artemisia/emitter'
require 'artemisia/manager'

module Artemisia
  module Managers
    class ComponentManager < Manager
      include Emitter

      def initialize(attributes)
        attributes.type = :component_manager
        super(attributes)

        # { location: { entity_id_1: { x: 1, y: 2, z: 3 } } }
        @components = {}
      end

      def add_component(entity_id, component)
        components_by_type(component.type)[entity_id] = component

        emit(:component_added_to_entity, entity_id, component)

        self
      end

      def remove_component(entity_id, component)
        component_removed = @components[component.type].delete(entity_id)

        emit(:component_removed_from_entity, entity_id, component_removed)

        self
      end

      def all_components(component_type)
        (@components[component_type] ||= {}).values
      end

      def components_by_type(component_type)
        (@components[component_type] ||= {})
      end

      def component(entity_id, component_type)
        components_by_type(component_type)[entity_id]
      end
    end
  end
end
