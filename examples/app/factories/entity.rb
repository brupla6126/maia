require 'fabrication'
require 'artemisia/entity'

Fabricator(:entity, class_name: Artemisia::Entity) do
  sequence(:id) { |n| "entity-#{n}" }
  #  tag 'evil'
  groups []
  components []

  on_init { init_with(attributes) }
end
