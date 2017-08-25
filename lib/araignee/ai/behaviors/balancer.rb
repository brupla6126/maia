require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # balancer will pick one node amongst many to run
    # will return the picked node state if one
    # otherwise will return success
    class Balancer < Composite
      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        node = pick_node(nodes.select(&:running?))

        if node
          node.process(entity, world)

          fire_state_event(node.state_name) unless node.running?
        else
          fire_state_event(:success)
        end

        self
      end
    end

    protected

    # Derived classes must implement and return a node
    def pick_node(_nodes)
      raise NotImplementedError
    end
  end
end
