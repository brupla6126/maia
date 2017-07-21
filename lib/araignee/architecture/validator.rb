require 'singleton'

module Araignee
  module Architecture
    # Validator helper part of Clean Architecture.
    # It validates an entity and returns a result object.
    class Validator
      include Singleton

      def validate(entity, context = nil)
        result = Result.new
        result << validate_entity(entity, context)
        result
      end

      protected

      # to be implemented in derived classes
      def validate_entity(_entity, _context)
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
