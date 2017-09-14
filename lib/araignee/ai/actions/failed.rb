require 'araignee/ai/actions/action'
require 'araignee/ai/traits/prioritized'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionFailed < AI::Actions::Action
      include AI::Traits::Prioritized

      def process(entity, world)
        super(entity, world)

        update_response(:failed)

        self
      end
    end

    class ActionTemporaryFailed < Action
      attribute :times, Integer, default: 0

      def process(entity, world)
        super(entity, world)

        @called ||= 1

        response =
          if @called <= @times
            :failed
          else
            :succeeded
          end

        update_response(response)

        @called += 1

        self
      end
    end
  end
end
