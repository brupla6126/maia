# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Random selectors pick one of their child nodes randomly
    module Ordering
      module OrderRandom
        def order_nodes(nodes, _reverse = false)
          nodes.shuffle
        end
      end
    end
  end
end
