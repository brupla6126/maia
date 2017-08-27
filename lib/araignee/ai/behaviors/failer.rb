require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A failer will always return failure, irrespective of what the child node actually returned. These are useful in cases where you want to process a branch of a tree where a success is expected or anticipated, but you do not want to abandon processing of a sequence that branch sits on
    class Failer < AI::Decorator
      def process(entity, world)
        super

        @node.process(entity, world) if @node.active?

        failure! unless failed?

        self
      end
    end
  end
end
