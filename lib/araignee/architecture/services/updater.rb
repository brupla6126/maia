require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/finder'
require 'araignee/architecture/services/service'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Updater service part of Clean Architecture.
    # Base class to update an entity and return a result object.
    class Updater
      include Singleton
      include Service

      attr_reader :attributes

      def execute(id, attributes)
        raise NotImplementedError, 'must derive this class' if self.class == Araignee::Architecture::Updater

        @id = id
        @attributes = attributes

        update
      end

      protected

      def update
        find_entity

        update_entity if @entity

        save_entity if validation.successful?

        result
      end

      def find_entity
        result_one = sibling_class(:finder).instance.one(id: @id)
        @entity = result_one.entity if result_one.successful?
      end

      def update_entity
        @entity.attributes = @attributes
      end

      def save_entity
        repository.save(@entity)
      end

      private

      def validation
        @validation ||= validator.execute(@entity, @context)
      end

      def result
        Result.new(@id, @entity, validation.messages)
      end

      # Result class for Updater
      class Result
        attr_reader :id, :entity, :messages

        def initialize(id, entity, messages = [])
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
