require 'araignee/ai/core/pickers/picker'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Pickers are utility classes that pick and return
      # node(s) from an array of nodes
      module Pickers
        # Picks node(s) randomly
        class PickerRandom < Picker
          # pick many nodes at random
          def pick(nodes)
            return nodes if nodes.empty?

            nodes.shuffle[0...Random.rand(nodes.count)]
          end
        end
      end
    end
  end
end
