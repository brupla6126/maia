require 'fabrication'
require 'artemisia/component'

Fabricator(:location, class_name: Artemisia::Component) do
  x 0.0
  x 0.0
  z 0.0

  on_init { init_with(attributes) }
end
