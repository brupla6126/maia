require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # The Limiter decorator imposes a times number of calls its children
    # can have within the whole execution of the Behavior Tree,
    # i.e., after a certain number of calls, its child will never
    # be called again unless the Limiter is restarted.
    class Limiter < Decorator
      attribute :times, Integer, default: 0, writer: :protected
      attribute :limit, Integer, default: 1

      def execute(entity, world)
        @times = times + 1

        responded =
          if times <= limit
            child.process(entity, world).response
          else
            :failed
          end

        update_response(handle_response(responded))
      end

      protected

      def handle_response(responded)
        return responded if %i[busy failed].include?(responded)

        :succeeded
      end

      def reset_node
        super()

        reset_attribute(:times)
      end

      def validate_attributes
        super()

        raise ArgumentError, 'limit must be > 0' unless limit.positive?
      end
    end
  end
end
