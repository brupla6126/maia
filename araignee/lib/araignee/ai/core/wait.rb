require 'araignee/ai/core/node'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # The Wait node response is set to :succeeded after a certain
      # amount of time has passed. Meanwhile it is set to :busy
      class Wait < Node
        def reset_node
          super()

          reset_attribute(:start_time)
        end

        protected

        def default_attributes
          super().merge(
            delay: 0,
            start_time: Time.now
          )
        end

        def execute(_entity, _world)
          update_response(handle_response)
        end

        def handle_response
          if Time.now - start_time > delay
            :succeeded
          else
            :busy
          end
        end

        def validate_attributes
          super()

          raise ArgumentError, 'delay must be > 0' unless delay.positive?
        end
      end
    end
  end
end
