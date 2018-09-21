require 'fabrication'
require 'artemisia/component'

Fabricator(:identification, class_name: Artemisia::Component) do
  type
  id '?'
  name

  on_init { init_with(attributes) }
end
