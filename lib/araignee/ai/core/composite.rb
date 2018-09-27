require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker'
require 'araignee/ai/core/sorters/sorter'

module Ai
  module Core
    # A Composite Node Class, based on the Composite Design Pattern
    class Composite < Node
      attribute :children, Array, default: []
      attribute :filters, Array, default: []
      attribute :picker, Object, default: nil # Ai::Core::Pickers::Picker
      attribute :sorter, Object, default: nil # Ai::Core::Sorters::Sorter
      attribute :sort_reverse, Boolean, default: false

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

        picker&.reset
        sorter&.reset

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

      def filter(nodes)
        return nodes if filters.empty? || nodes.empty?

        accepted_nodes = filters.map { |filter| filter.accept(nodes) }.flatten.compact
        rejected_nodes = filters.map { |filter| filter.reject(nodes) }.flatten.compact

        accepted_nodes.uniq - rejected_nodes.uniq
      end

      def pick_one(nodes)
        return nil unless picker

        picker.pick_one(nodes)
      end

      def pick_many(nodes)
        return nodes unless picker

        picker.pick_many(nodes)
      end

      def sort(nodes, reverse)
        return nodes unless sorter

        sorter.sort(nodes, reverse) unless nodes.empty?

        nodes
      end
    end
  end
end
