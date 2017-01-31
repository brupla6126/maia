require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/service'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Creator service part of Clean Architecture.
    # Base class to create an entity and return a result object.
    class Creator
      include Singleton
      include Service

      attr_reader :attributes

      def execute(attributes, context = nil)
        @attributes = attributes
        @context = context || {}

        raise NotImplementedError, 'must derive this class' if self.class == Araignee::Architecture::Creator

        create
      end

      protected

      def create
        create_entity

        save_entity if validation.successful?

        result
      end

      def create_entity
        @entity ||= entity_class.new(@attributes)
      end

      def save_entity
        repository.create(@entity)
      end

      private

      def validation
        @validation ||= validator.execute(@entity, @context)
      end

      def result
        Result.new(@entity, validation.messages)
      end

      # Result class for Creator
      class Result
        attr_reader :entity, :messages

        def initialize(entity, messages = [])
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
