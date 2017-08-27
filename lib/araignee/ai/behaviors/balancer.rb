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

        node = pick_node(@nodes.select(&:active?))

        if node
          handle_result(node.process(entity, world).state_name)
        else
          succeed! unless succeeded?
        end

        self
      end
    end

    protected

    def handle_result(state)
      case state
      when :succeeded
        succeed! unless succeeded?
      when :failed
        failure! unless failed?
      when :running
        busy! unless running?
      end
    end

    # Derived classes must implement and return a node
    def pick_node(_nodes)
      raise NotImplementedError
    end
  end
end
