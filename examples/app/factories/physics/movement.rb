require 'fabrication'
require 'artemisia/component'

Fabricator(:movement, class_name: Artemisia::Component) do
  dx 0.0
  dx 0.0
  dz 0.0

  on_init { init_with(attributes) }
end
