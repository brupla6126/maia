require 'araignee/ai/actions/action'
require 'araignee/ai/traits/prioritized'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionSucceeded < Action
      include AI::Traits::Prioritized

      def process(entity, world)
        super

        entity[:number] += 1

        fire_state_event(:success)

        self
      end
    end

    class ActionTemporarySucceeded < Action
      attribute :times, Integer, default: 0

      def process(entity, world)
        super

        @called ||= 1

        if @called <= @times
          fire_state_event(:success)
        else
          fire_state_event(:start)
          fire_state_event(:failure)
        end

        @called += 1

        self
      end
    end
  end
end
