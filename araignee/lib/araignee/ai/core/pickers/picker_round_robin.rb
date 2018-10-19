require 'araignee/ai/core/pickers/picker'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Pickers are utility classes that pick and return
      # node(s) from an array of nodes
      module Pickers
        # Picks node(s) in round robin fashion
        class PickerRoundRobin < Picker
          # pick a node round robin fashion
          def pick(nodes)
            node = nodes[current]

            self.current = current == nodes.count - 1 ? 0 : current + 1

            [node]
          end

          def reset
            reset_attribute(:current)

            self
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
end
