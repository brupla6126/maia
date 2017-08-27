require 'araignee/ai/actions/action'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionStopped < AI::Actions::Action
      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        stop! unless stopped?

        self
      end
    end
  end
end
