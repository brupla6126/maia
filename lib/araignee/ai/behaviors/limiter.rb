require 'araignee/ai/decorator'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # This decorator imposes a times number of calls its child can have within the whole execution of the Behavior Tree, i.e., after a certain number of calls, its child will never be called again.
    class Limiter < AI::Decorator
      attribute :count, Integer, default: 0, writer: :private
      attribute :times, Integer, default: 1

      def process(entity, world)
        super(entity, world)

        response =
          if @count < @times
            @count += 1

            node.process(entity, world).response
          else
            :failed
          end

        update_response(handle_response(response))

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

      def validate_attributes
        super

        raise ArgumentError, 'times must be > 0' unless @times > 0
      end
    end
  end
end
