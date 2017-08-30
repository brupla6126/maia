require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A Guard Node will evaluate an assertion and if it returns
    # :succeeded it will process the guarded node
    class Guard < Composite
      # expects nodes[0] be the assertion
      # expects nodes[1] be the guarded node
      def initialize(attributes = {})
        super

        @assertion_identifier = @nodes[0].identifier
        @guarded_identifier = @nodes[1].identifier
      end

      # if assertion evaluate to :succeeded, the guard
      # will return the processed node state otherwise
      # returns :succeeded
      def process(entity, world)
        super

        result = :succeeded

        assertion = child(@assertion_identifier)
        assertion.process(entity, world)

        if assertion.succeeded?
          guarded = child(@guarded_identifier)
          result = guarded.process(entity, world).state_name
        end

        handle_result(result)

        self
      end

      protected

      def handle_result(result)
        case result
        when :failed then failure! unless failed?
        when :running then busy! unless running?
        else
          succeed! unless succeeded?
        end
      end

      def validate_attributes
        super

        raise ArgumentError, 'assertion_identifier nil' unless @assertion_identifier
        raise ArgumentError, 'guarded_identifier nil' unless @guarded_identifier
      end
    end
  end
end
