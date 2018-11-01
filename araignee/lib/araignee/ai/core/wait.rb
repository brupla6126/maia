require 'araignee/ai/core/node'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # The Wait node response is set to :succeeded after a certain
      # amount of time has passed. Meanwhile it is set to :busy
      class Wait < Node
        def reset
          super()

          state.start_time = Time.now

          self
        end

        protected

        def execute(_entity, _world)
          raise ArgumentError, 'delay must be > 0' unless state.delay.positive?

          state.start_time ||= Time.now

          update_response(handle_response)
        end

        def handle_response
          if Time.now - state.start_time > state.delay
            :succeeded
          else
            :busy
          end
        end
      end
    end
  end
end
