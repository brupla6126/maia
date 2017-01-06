module Araignee
  module Architecture
    # Validator validates an entity
    class Validator
      attr_reader :entity

      def self.execute(entity)
        new(entity).validate
      end

      def initialize(entity)
        @entity = entity
      end

      def validate
        result = Result.new
        result << validate_entity
        result
      end

      protected

      def validate_entity
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

        def <<(message)
          @messages << message if message
        end
      end
    end
  end
end
