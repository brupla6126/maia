require 'singleton'

module Araignee
  module Architecture
    # Validator service part of Clean Architecture.
    # It validates an entity and returns a result object.
    class Validator
      include Singleton

      attr_reader :entity

      def execute(entity, context = {})
        @entity = entity
        @context = context || {}

        validate_entity
      end

      protected

      def validate_entity
        result = Result.new
        result << validate
        result
      end

      def validate
      end

      # Result class for Validator
      class Result
        attr_reader :messages

        def initialize
          @messages = []
        end

        def successful?
          @messages.empty?
        end

        def <<(messages)
          @messages += messages if messages
        end
      end
    end
  end
end
