require 'artemisia/emitter'
require 'artemisia/manager'

module Artemisia
  module Managers
    class EntityManager < Manager
      include Emitter

      def initialize(attributes)
        attributes.type = :entity_manager
        super(attributes)

        @entities = []
        @disabled = []
      end

      # entity_id String
      def add(entity_id)
        already = @entities.include?(entity_id)

        @entities << entity_id unless already

        emit(:entity_added, entity_id) unless already

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
        already_disabled = @disabled.include?(entity_id)

        @disabled << entity_id unless already_disabled

        emit(:entity_disabled, entity_id) unless already_disabled

        self
      end
    end
  end
end
