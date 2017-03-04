require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/finder'
require 'araignee/architecture/services/service'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Forward declaration to solve circular dependencies
    module Service
    end

    # Updater service part of Clean Architecture.
    # Base class to update an entity and return a result object.
    class Updater
      include Singleton
      include Service

      attr_reader :attributes

      def update(klass: nil, id: nil, attributes: {})
        raise ArgumentError, 'klass invalid' unless klass
        raise ArgumentError, 'id invalid' unless id
        raise ArgumentError, 'attributes empty' if attributes.empty?

        entity = find_entity(klass, id)

        entity = update_entity(entity, attributes) if entity

        validation = validate_entity(klass, entity)

        save_entity(klass, entity) if validation.successful?

        Result.new(klass, id, entity, validation.messages)
      end

      protected

      def find_entity(klass, id)
        result_one = finder(klass).one(klass: klass, filters: { id: id })
        result_one.entity if result_one.successful?
      end

      def update_entity(entity, attributes)
        entity.attributes = attributes
        entity
      end

      def save_entity(klass, entity)
        storage(klass).update(entity)
      end

      def validate_entity(klass, entity)
        validator(klass).validate(klass: klass, entity: entity)
      end

      # Result class for Updater
      class Result
        attr_reader :id, :entity, :messages

        def initialize(klass, id, entity, messages = [])
          @klass = klass
          @id = id
          @entity = entity
          @messages = messages
        end

        def successful?
          @messages.empty?
        end
      end
    end
  end
end
