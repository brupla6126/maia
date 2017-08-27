require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A repeater will reprocess its child node each time its child
    # returns a result. These are often used at the very base of the
    # tree, to make the tree to run continuously. Repeaters may optionally
    # run their children a set number of times before returning to their parent
    class Repeater < Decorator
      def process(entity, world)
        super

        repeat_process(entity, world) if @node.active?

        self
      end

      protected

      def repeat_process(entity, world); end
    end
  end
end
