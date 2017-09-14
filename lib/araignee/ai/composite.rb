require 'araignee/ai/node'

module AI
  # A Composite Node Class, based on the Composite Design Pattern
  class Composite < Node
    attribute :nodes, Array, default: []

    def initialize(attributes)
      super(attributes)
    end

    def child(identifier)
      nodes.select { |node| node.identifier.equal?(identifier) }.first
    end

    def add_node(node, index)
      index ||= :last

      raise ArgumentError, "invalid index: #{index}" unless index.equal?(:last) || index.is_a?(Integer)

      if index.equal?(:last)
        nodes << node
      else
        nodes.insert(index, node)
      end
    end

    def remove_node(node)
      nodes.delete(node)
    end

    def reset_node
      super()

      # reset children nodes
      nodes.each(&:reset_node)

      nil
    end

    protected

    def node_starting
      super()

      nodes.each(&:start!)

      nil
    end

    def node_stopping
      super()

      nodes.each(&:stop!)

      nil
    end

    def validate_attributes
      super()

      raise ArgumentError, 'nodes must be Array' if nodes.empty?
    end
  end
end
