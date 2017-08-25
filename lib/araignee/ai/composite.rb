require 'araignee/ai/node'

module AI
  # A Composite Node Class, based on the Composite Design Pattern
  class Composite < Node
    attribute :nodes, Array, default: []

    def initialize(attributes = {})
      super
    end

    def add_node(node, index = :last)
      if index == :last
        @nodes << node
      else
        @nodes.insert(index, node)
      end
    end

    def remove_node(node)
      @nodes.delete(node)
    end

    protected

    def start_node
      super

      @nodes.each { |node| node.fire_state_event(:start) }
    end

    def reset_node
      super

      # reset children nodes
      @nodes.each(&:reset_node)
    end

    def validate_attributes
      super

      Log[self.class].warn { 'node: #{inspect} has no children' } if @nodes.empty?
    end
  end
end
