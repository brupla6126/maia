require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker'
require 'araignee/ai/core/sorters/sorter'

module Araignee
  module Ai
    module Core
      # A Composite Node Class, based on the Composite Design Pattern
      class Composite < Node
        def child(identifier)
          children.detect { |child| child.identifier.equal?(identifier) }
        end

        def reset
          super()

          # reset children children
          children.each(&:reset)

          picker&.reset
          sorter&.reset

          self
        end

        def nodes
          sort(pick(filter(children)), sort_reversed)
        end

        protected

        def default_attributes
          super().merge(
            children: [], # Ai::Core::Node derived
            filters: [],
            picker: nil, # Ai::Core::Pickers::Picker derived
            sorter: nil, # Ai::Core::Sorters::Sorter derived
            sort_reversed: false
          )
        end

        def filter(nodes)
          return nodes if filters.empty? || nodes.empty?

          accepted_nodes = filters.map { |filter| filter.accept(nodes) }.flatten.compact
          rejected_nodes = filters.map { |filter| filter.reject(nodes) }.flatten.compact

          (accepted_nodes - rejected_nodes).uniq
        end

        def pick(nodes)
          return nodes unless picker

          picker.pick(nodes)
        end

        def sort(nodes, reversed)
          return nodes unless sorter && nodes.any?

          sorter.sort(nodes, reversed)
        end
      end
    end
  end
end
