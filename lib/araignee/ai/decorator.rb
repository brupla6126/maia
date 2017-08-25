require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # A Decorator Node Class, based on the Decorator Design Pattern
  class Decorator < Node
    attribute :node, Node, default: nil

    def initialize(attributes = {})
      super
    end

    def node=(new_node)
      @node.cancel if @node && @node.running?

      super(new_node)
    end

    protected

    def start_node
      super

      @node.fire_state_event(:start)
    end

    def reset_node
      super

      # reset decorating node
      @node.reset_node if @node
    end

    def validate_attributes
      super

      raise ArgumentError, 'node nil' unless @node
    end
  end
end
