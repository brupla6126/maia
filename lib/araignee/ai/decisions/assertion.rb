require 'araignee/ai/leaf'

# Module for gathering AI classes
module AI
  # Module for gathering Decision classes
  module Decisions
    # An Assertion Node will evaluate a condition and
    # its response can only be :succeeded or :failed
    # Derived classed will implement the assertion test
    class Assertion < Leaf
      def process(entity, world)
        super(entity, world)

        response = assert(entity, world)

        update_response(handle_response(response))

        self
      end

      protected

      def assert(_entity, _world)
        raise NotImplementedError
      end

      private

      def handle_response(response)
        # only accept :succeeded and :failed
        case response
        when :succeeded then :succeeded
        else
          :failed
        end
      end
    end
  end
end
