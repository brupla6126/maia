# Module for gathering AI classes
module Ai
  module Core
    # Sorters are utility classes that sort nodes
    module Sorters
      # A Sorter derived class will sort node(s) its own way.
      class Sorter
        # default behavior is to return nodes as received
        def sort(nodes, _reverse = false)
          nodes
        end

        # to reset a sorter's state
        def reset; end
      end
    end
  end
end
