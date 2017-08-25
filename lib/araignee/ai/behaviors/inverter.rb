require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Inverter will invert or negate the result of their child node.
    # Success becomes failure, and failure becomes success.
    class Inverter < Decorator
      def process(entity, world)
        super

        @node.process(entity, world)

        fire_state_event(:failure) if @node.succeeded?
        fire_state_event(:success) if @node.failed?

        self
      end

      protected

      def validate_attributes
        super

        raise ArgumentError, ':node must be set' unless @node
      end
    end
  end
end
