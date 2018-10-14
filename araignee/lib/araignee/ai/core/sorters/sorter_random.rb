module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Sorters are utility classes that sort nodes
      module Sorters
        # A Sorter that sorts nodes randomly.
        class SorterRandom
          def sort(nodes, _reverse = false)
            nodes.shuffle
          end
        end
      end
    end
  end
end
