require 'araignee/ai/core/node'

# Module for gathering AI classes
module Ai
  module Core
    # The Timeout node return a response :failed after a certain
    # amount of time has passed.
    class Timeout < Node
      attribute :delay, Integer, default: 0
      attribute :start_time, Time, default: ->(_node, _attribute) { Time.now }

      def execute(_entity, _world)
        update_response(handle_response)
      end

      protected

      def reset_node
        super()

        reset_attribute(:start_time)
      end

      def handle_response
        if Time.now - start_time > delay
          :failed
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
