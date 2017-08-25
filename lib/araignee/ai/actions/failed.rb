require 'araignee/ai/actions/action'
require 'araignee/ai/traits/prioritized'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionFailed < AI::Actions::Action
      include AI::Traits::Prioritized

      def process(entity, world)
        super

        fire_state_event(:failure)

        self
      end
    end

    class ActionTemporaryFailed < Action
      attribute :times, Integer, default: 0

      def process(entity, world)
        super

        @called ||= 1

        if @called <= @times
          fire_state_event(:failure)
        else
          fire_state_event(:start)
          fire_state_event(:success)
        end

        @called += 1

        self
      end
    end
  end
end
