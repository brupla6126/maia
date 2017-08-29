require 'araignee/ai/leaf'

# Module for gathering AI classes
module AI
  # Module for gathering Decision classes
  module Decisions
    # An Assertion Node will evaluate a condition and
    # its resulting state can only be :succeeded or :failed
    # Derived classed will implement the assertion test
    class Assertion < Leaf
      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        result = assert(entity, world)

        handle_result(result)

        self
      end

      protected

      def assert(_entity, _world)
        raise NotImplementedError
      end

      private

      def handle_result(result)
        # only accept :succeeded and :failed
        case result
        when :succeeded then succeed! unless succeeded?
        else
          failure! unless failed?
        end
      end
    end
  end
end
