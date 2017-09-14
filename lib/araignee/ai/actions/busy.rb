require 'araignee/ai/actions/action'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionBusy < AI::Actions::Action
      def process(entity, world)
        super(entity, world)

        update_response(:busy)

        self
      end
    end
  end
end
