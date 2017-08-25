require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Max Time limits the maximum time its child can be running. If the child does not complete its execution before the maximum time, the child task is canceled and a failure is returned
    class Expiration < AI::Decorator
      attribute :expires, Integer, default: 0
      attribute :start_time, Time, default: Time.now

      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        reset_attribute(:start_time) unless @start_time

        @elapsed = Time.now - @start_time

        if @elapsed <= @expires
          fire_state_event(:success) if @node.process(entity, world).succeeded?
        else
          Log.debug { "#{self.class} Elapsed..." }

          @node.fire_state_event(:cancel)

          fire_state_event(:failure)
        end

        self
      end

      protected

      def start_node
        super

        reset_attribute(:start_time)
      end

      def reset_node
        super

        reset_attribute(:elapsed)
        reset_attribute(:start_time)
      end

      def validate_attributes
        super

        raise ArgumentError, ':expires not set' unless @expires
      end
    end
  end
end
