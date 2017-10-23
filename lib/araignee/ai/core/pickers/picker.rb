require 'virtus'

# Module for gathering AI classes
module Ai
  module Core
    # Pickers are utility classes that pick and return
    # node(s) from an array of nodes
    module Pickers
      # A Picker derived class will pick node(s).
      class Picker
        include Virtus.model

        # default behavior is to return nil
        def pick_one(_nodes); end

        # default behavior is to return all nodes
        def pick_many(nodes)
          nodes
        end
      end
    end
  end
end
