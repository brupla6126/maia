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

    def node_starting
      super

      @node.start!
    end

    def node_stopping
      super

      @node.stop!
    end

    def reset_node
      super

      @node.reset_node if @node
    end

    def validate_attributes
      super

      raise ArgumentError, 'node nil' unless @node
    end
  end
end
