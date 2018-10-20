require 'araignee/ai/core/decorator'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # The Limiter decorator imposes a times number of calls its children
      # can have within the whole execution of the Behavior Tree,
      # i.e., after a certain number of calls, its child will never
      # be called again unless the Limiter is restarted.
      class Limiter < Decorator
        def reset
          super()

          reset_attribute(:times)

          self
        end

        protected

        def default_attributes
          super().merge(
            times: 0,
            limit: 1
          )
        end

        def execute(entity, world)
          raise ArgumentError, 'limit must be > 0' unless limit.positive?

          self.times += 1

          responded =
            if times <= limit
              child.process(entity, world).response
            else
              :failed
            end

          update_response(handle_response(responded))
        end

        def handle_response(responded)
          return responded if %i[busy failed].include?(responded)

          :succeeded
        end
      end
    end
  end
end
