require 'araignee/ai/actions/action'
require 'araignee/ai/traits/prioritized'
require 'araignee/ai/traits/probability'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree Action classes
  module Actions
    class ActionLuckiest < AI::Actions::Action
      include AI::Traits::Probability

      def initialize(attributes = {})
        super(attributes.merge(probability: 70))
      end
    end

    class ActionBummer < AI::Actions::Action
      include AI::Traits::Probability

      def initialize(attributes = {})
        super(attributes.merge(probability: 40))
      end
    end

    class ActionLooser < AI::Actions::Action
      include AI::Traits::Probability

      def initialize(attributes = {})
        super(attributes.merge(probability: 10))
      end
    end
  end
end
