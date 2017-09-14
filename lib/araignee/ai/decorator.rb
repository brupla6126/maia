require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # A Decorator Node Class, based on the Decorator Design Pattern
  class Decorator < Node
    attribute :node, Node, default: nil

    def initialize(attributes)
      super(attributes)
    end

    def node=(new_node)
      raise ArgumentError, 'invalid decorating node' unless new_node

      node.stop! if node && node.can_stop?

      super(new_node)

      node.start! if running?
    end

    protected

    def node_starting
      super()

      node.start!
    end

    def node_stopping
      super()

      node.stop!
    end

    def validate_attributes
      super()

      raise ArgumentError, 'invalid decorating node' unless node
    end
  end
end
