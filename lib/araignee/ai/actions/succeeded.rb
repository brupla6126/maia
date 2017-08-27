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

        succeed! unless succeeded?

        self
      end
    end

    class ActionTemporarySucceeded < Action
      attribute :times, Integer, default: 0

      def process(entity, world)
        super

        @called ||= 1

        if @called <= @times
          succeed! unless succeeded?
        else
          start! unless started?
          failure!
        end

        @called += 1

        self
      end
    end
  end
end
