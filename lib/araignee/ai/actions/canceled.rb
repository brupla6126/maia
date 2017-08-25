require 'araignee/ai/actions/action'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionCanceled < AI::Actions::Action
      def initialize(attributes = {})
        super
      end

      def start_node
        fire_state_event(:cancel)
      end
    end
  end
end
