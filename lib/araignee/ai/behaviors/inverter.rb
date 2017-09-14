require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Inverter will invert or negate the result of their child node.
    # Success becomes failure, and failure becomes success.
    class Inverter < Decorator
      def process(entity, world)
        super(entity, world)

        response = @node.process(entity, world).response

        update_response(handle_response(response))

        self
      end

      protected

      def handle_response(response)
        case response
        when :succeeded
          :failed
        when :failed
          :succeeded
        else
          response
        end
      end

      def validate_attributes
        super

        raise ArgumentError, 'node must be set' unless node
      end
    end
  end
end
