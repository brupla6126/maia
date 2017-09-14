require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # balancer will pick one node amongst many to run
    # will return the picked node state if one
    # otherwise will return success
    class Balancer < Composite
      def initialize(attributes)
        super(attributes)
      end

      def process(entity, world)
        super(entity, world)

        node = pick_node(@nodes.select(&:running?))

        response = :succeeded

        response = handle_response(node.process(entity, world).response) if node

        update_response(response)

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

      # Derived classes must implement and return a node
      def pick_node(_nodes)
        raise NotImplementedError
      end
    end
  end
end
