require 'araignee/ai/core/node'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # The Timeout node return a response :failed after a certain
      # amount of time has passed.
      class Timeout < Node
        def reset
          super()

          state.start_time = Time.now

          self
        end

        protected

        def execute(_request)
          raise ArgumentError, 'delay must be > 0' unless state.delay.positive?

          update_response(handle_response)
        end

        def valid_response?(response)
          %i[busy failed].include?(response)
        end

        def handle_response
          if Time.now - state.start_time > state.delay
            :failed
          else
            :busy
          end
        end
      end
    end
  end
end
