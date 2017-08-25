require 'araignee/ai/actions/action'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionRunning < AI::Actions::Action
      def process(entity, world)
        super

        self
      end
    end
  end
end
