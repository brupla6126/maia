# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # For picking a single node
    module Picking
      module PickRandom
        # pick a node at random
        def pick_node(nodes)
          nodes.sample
        end
      end
    end
  end
end
