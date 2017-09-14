require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Max Time limits the maximum time its child can be running. If the child does not complete its execution before the maximum time, the child task is stopped and a failure is returned
    class Expiration < AI::Decorator
      attribute :expires, Integer, default: 0
      attribute :start_time, Time, default: Time.now

      def process(entity, world)
        super(entity, world)

        if @node.running?
          reset_attribute(:start_time) unless @start_time

          @elapsed = Time.now - @start_time

          response =
            if @elapsed <= @expires
              if !@node.busy?
                @node.response
              else
                @node.process(entity, world).response
              end
            else
              Log[:ai].debug { "Elapsed: #{node.inspect}" }

              @node.stop!

              :failed
            end

          update_response(handle_response(response))
        end

        self
      end

      protected

      def handle_response(response)
        case response
        when :failed
          :failed
        when :busy
          :busy
        else
          :succeeded
        end
      end

      def node_starting
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
