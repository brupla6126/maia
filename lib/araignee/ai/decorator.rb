require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # A Decorator Node Class, based on the Decorator Design Pattern
  class Decorator < Node
    attribute :child, Node, default: nil

    def initialize
      super()
    end

    def child=(new_child)
      raise ArgumentError, 'invalid decorating child' unless new_child

      child.stop! if child && child.can_stop?

      super(new_child)

      child.start! if running?
    end

    protected

    def node_starting
      super()

      child.start!
    end

    def node_stopping
      super()

      child.stop!
    end
  end
end
