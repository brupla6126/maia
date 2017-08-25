# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Ordering nodes for Selectors
    module Ordering
      module OrderPriority
        # nodes Array of AI::Node
        # reverse Will sort nodes ascending unless true
        def order_nodes(nodes, reverse = false)
          sorted = nodes.sort_by(&:priority)
          sorted.reverse! if reverse

          sorted
        end
      end
    end
  end
end
