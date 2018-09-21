require 'fabrication'
require 'artemisia/systems/entity_system'

Fabricator(:entity_system, class_name: Artemisia::Systems::EntitySystem) do
  aspect :aspect_moving
  active true

  association :clock, factory: :clock

  on_init { init_with(attributes) }
end
