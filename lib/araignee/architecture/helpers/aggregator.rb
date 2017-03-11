require 'singleton'

module Araignee
  module Architecture
    module Helpers
      # Aggregator helper.
      # Base class to aggregate data from entities and return a result object.
      class Aggregator
        include Singleton

        attr_reader :attributes

        def execute(attributes, context = nil)
          @attributes = attributes
          @context = context || {}

          aggregate

          result
        end

        def aggregate
        end

        def result
          Result.new(@entity) # , validation.messages
        end

        # Result class for Aggregator
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
end
