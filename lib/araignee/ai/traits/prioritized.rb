require 'virtus'

# Module for gathering AI classes
module AI
  module Traits
    # Prioritized trait
    module Prioritized
      include Virtus.module

      attribute :priority, Integer, default: 0

      # delta Integer can be negative
      def prioritize(delta = 1)
        @priority += delta
      end
    end
  end
end
