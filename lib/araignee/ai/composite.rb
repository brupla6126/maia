require 'araignee/ai/node'

module AI
  # A Composite Node Class, based on the Composite Design Pattern
  class Composite < Node
    attribute :nodes, Array, default: []

    def initialize(attributes = {})
      super
    end

    def child(identifier)
      @nodes.select { |node| node.identifier == identifier }.first
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

    def node_starting
      super

      @nodes.each(&:start!)
    end

    def node_stopping
      super

      @nodes.each(&:stop!)
    end

    def reset_node
      super

      # reset children nodes
      @nodes.each(&:reset_node)
    end

    def validate_attributes
      super

      Log[:ai].warn { "node: #{inspect} has no children" } if @nodes.empty?
    end
  end
end
