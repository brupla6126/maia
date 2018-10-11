require 'araignee/utils/emitter'
require 'artemisia/manager'

module Artemisia
  module Managers
    # To group entities together like "monsters", "fireballs".
    # An entity can be assigned to more than one group.
    # A group can be assigned to more than one entity.
    class GroupManager < Manager
      include Araignee::Utils::Emitter

      def initialize(attributes)
        attributes.type = :group_manager
        super(attributes)

        @group_entities = {}
        @entity_groups = {}
      end

      # adds an entity to a group
      # entity_id String
      # group String
      def add(entity_id, group)
        entities(group) << entity_id
        groups(entity_id) << group

        emit(:entity_added_to_group, group, entity_id)

        self
      end

      # removes entity from a group
      # entity_id String
      # group String
      def remove(entity_id, group)
        entities(group).delete(entity_id)
        groups(entity_id).delete(group)

        emit(:entity_removed_from_group, group, entity_id)

        self
      end

      # entity_id String
      def remove_from_groups(entity_id)
        groups(entity_id).dup.each do |group|
          remove(entity_id, group)
        end

        self
      end

      # group String
      def entities(group)
        @group_entities[group] ||= []
      end

      # entity_id String
      def groups(entity_id)
        @entity_groups[entity_id] ||= []
      end

      # entity_id String
      def any_group?(entity_id)
        !groups(entity_id).empty?
      end

      # entity_id String
      # group String
      def in_group?(entity_id, group)
        groups(entity_id).include?(group)
      end
    end
  end
end
