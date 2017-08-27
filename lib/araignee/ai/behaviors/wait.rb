require 'araignee/ai/leaf'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # The Wait node SUCCEEDS after a certain amount of time has passed
    class Wait < Leaf
      attribute :delay, Integer, default: 0
      attribute :start_time, Time, default: Time.now

      def process(entity, world)
        super

        reset_attribute(:start_time) unless @start_time

        if Time.now - @start_time > @delay
          succeed!
        else
          busy!
        end

        self
      end

      protected

      def node_starting
        super

        reset_attribute(:start_time)
      end

      def reset_node
        super

        reset_attribute(:start_time)
      end

      def validate_attributes
        super

        raise ArgumentError, 'delay must be > 0' unless @delay.positive?
      end
    end
  end
end
