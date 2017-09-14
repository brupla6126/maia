require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A Condition Node will evaluate a term and if it returns
    # true it will process the yes node otherwise will process
    # the no node
    class Condition < Composite
      # expects nodes[0] be the term
      # expects nodes[1] be the yes node
      # expects nodes[2] be the no node
      def initialize(attributes)
        super(attributes)
      end

      def process(entity, world)
        super(entity, world)

        case nodes[0].process(entity, world).response
        when :succeeded
          executing_node = nodes[1]
        when :failed
          executing_node = nodes[2]
        end

        response = :succeeded
        response = executing_node.process(entity, world).response if executing_node

        update_response(handle_response(response))

        self
      end

      protected

      def handle_response(response)
        case response
        when :failed then :failed
        when :busy then :busy
        else
          :succeeded
        end
      end

      def validate_attributes
        super()

        raise ArgumentError, 'term node must be set in nodes[0]' unless nodes.fetch(0)
        raise ArgumentError, 'yes node must be set in nodes[1]' unless nodes.fetch(1)
        raise ArgumentError, 'no node must be set in nodes[2]' unless nodes.fetch(2)
      end
    end
  end
end
