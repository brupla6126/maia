require 'ostruct'

# Module for gathering AI classes
module Ai
  module Core
    # Pickers are utility classes that pick and return
    # node(s) from an array of nodes
    module Pickers
      # A Picker derived class will pick node(s).
      class Picker < OpenStruct
        def initialize(state = {})
          super(default_attributes.merge(state))
        end

        # default behavior is to return nil
        def pick_one(_nodes); end

        # default behavior is to return all nodes
        def pick_many(nodes)
          nodes
        end

        def default_attributes
          {}
        end

        def reset_attribute(attribute)
          self[attribute] = default_attributes[attribute]
        end
      end
    end
  end
end
