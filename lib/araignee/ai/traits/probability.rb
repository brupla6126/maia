require 'virtus'

# Module for gathering AI classes
module AI
  module Traits
    # Probability trait
    module Probability
      include Virtus.module

      attribute :probability, Integer, default: 0
    end
  end
end
