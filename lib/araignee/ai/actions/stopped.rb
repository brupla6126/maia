require 'araignee/ai/actions/action'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionStopped < AI::Actions::Action
      def process(entity, world)
        super(entity, world)

        stop! if can_stop?

        self
      end
    end
  end
end
