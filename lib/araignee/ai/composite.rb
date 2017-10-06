require 'araignee/ai/node'

module AI
  # A Composite Node Class, based on the Composite Design Pattern
  class Composite < Node
    attribute :children, Array, default: []

    def initialize
      super()
    end

    def child(identifier)
      children.detect { |child| child.identifier.equal?(identifier) }
    end

    def add_child(child, index)
      index ||= :last

      raise ArgumentError, "invalid index: #{index}" unless index.equal?(:last) || index.instance_of?(Integer)

      if index.equal?(:last)
        children << child
      else
        children.insert(index, child)
      end

      self
    end

    def remove_child(child)
      children.delete(child)

      self
    end

    def reset_node
      super()

      # reset children children
      children.each(&:reset_node)

      nil
    end

    protected

    def node_starting
      super()

      children.each(&:start!)

      nil
    end

    def node_stopping
      super()

      children.each(&:stop!)

      nil
    end
  end
end
