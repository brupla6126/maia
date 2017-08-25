require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # A Leaf Node Class, does not have any children. It is usually an Action.
  class Leaf < Node
    def initialize(attributes = {})
      super
    end
  end
end
