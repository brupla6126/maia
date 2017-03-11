require 'singleton'

module Araignee
  module Architecture
    module Helpers
      # Forward declaration to solve circular dependencies
      module Helper
      end

      # Validator helper part of Clean Architecture.
      # It validates an entity and returns a result object.
      class Validator
        include Singleton

        def validate(klass: nil, entity: nil, context: nil)
          result = Result.new
          result << validate_entity(klass: klass, entity: entity, context: context)
          result
        end

        protected

        # to be implemented in derived classes
        def validate_entity(klass: nil, entity: nil, context: nil)
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
end
