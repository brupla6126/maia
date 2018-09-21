require 'fabrication'
require 'artemisia/component'

Fabricator(:aspect, class_name: Artemisia::Component) do
  one []
  all []
  exclude []

  on_init { init_with(attributes) }
end

Fabricator(:aspect_moving, from: :aspect) do
  one []
  all %i[location movement]
  exclude [:death]

  on_init { init_with(attributes) }
end
