require 'fabrication'
require 'artemisia/world'

Fabricator(:world, class_name: Artemisia::World) do
  sequence(:id) { |n| "world-#{n}" }

  # managers
  # systems

  on_init { init_with(attributes) }

  after_build do |world|
    world.managers[:tag_manager] ||= build(:tag_manager)
    world.managers[:group_manager] ||= build(:group_manager)
  end
end
