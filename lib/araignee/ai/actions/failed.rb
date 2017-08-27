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

        failure! unless failed?

        self
      end
    end

    class ActionTemporaryFailed < Action
      attribute :times, Integer, default: 0

      def process(entity, world)
        super

        @called ||= 1

        if @called <= @times
          failure! unless failed?
        else
          start! unless started?
          succeed!
        end

        @called += 1

        self
      end
    end
  end
end
