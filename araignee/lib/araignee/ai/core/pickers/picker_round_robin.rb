require 'araignee/ai/core/pickers/picker'

# Module for gathering AI classes
module Ai
  module Core
    # Pickers are utility classes that pick and return
    # node(s) from an array of nodes
    module Pickers
      # Picks node(s) in round robin fashion
      class PickerRoundRobin < Picker
        # pick a node round robin fashion
        def pick_one(nodes)
          node = nodes[self.current]

          self.current = self.current == nodes.count - 1 ? 0 : self.current + 1

          node
        end

        def reset
          reset_attribute(:current)
        end

        protected

        def default_attributes
          super().merge(
            current: 0
          )
        end
      end
    end
  end
end
