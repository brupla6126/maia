require 'araignee/utils/emitter'
require 'artemisia/manager'

module Artemisia
  module Managers
    class EntityManager < Manager
      include Araignee::Utils::Emitter

      def initialize(attributes)
        attributes.type = :entity_manager
        super(attributes)

        @entities = []
        @disabled = []
      end

      # entity_id String
      def add(entity_id)
        return self if @entities.include?(entity_id)

        @entities << entity_id

        emit(:entity_added, entity_id)

        self
      end

      # entity_id String
      def remove(entity_id)
        removed = @entities.delete(entity_id)

        emit(:entity_removed, entity_id) if removed

        self
      end

      # entity_id String
      def active?(entity_id)
        @entities.include?(entity_id)
      end

      # entity_id String
      def enable(entity_id)
        removed = @disabled.delete(entity_id)

        emit(:entity_enabled, entity_id) if removed

        self
      end

      # entity_id String
      def enabled?(entity_id)
        !@disabled.include?(entity_id)
      end

      # entity_id String
      def disable(entity_id)
        return self if @disabled.include?(entity_id)

        @disabled << entity_id

        emit(:entity_disabled, entity_id)

        self
      end
    end
  end
end
