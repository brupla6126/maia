require 'singleton'

module Araignee
  module Architecture
    # Validator service part of Clean Architecture.
    # It validates an entity and report a result object.
    class Validator
      include Singleton

      attr_reader :entity

      def execute(entity)
        @entity = entity

        validate_entity
      end

      protected

      def validate_entity
        result = Result.new
        result << validate
        result
      end

      def validate
        raise NotImplementedError
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
