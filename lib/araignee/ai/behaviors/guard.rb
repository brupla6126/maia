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
      def initialize(attributes)
        super(attributes)
      end

      # if assertion evaluate to :succeeded, the guard
      # will return the processed node state otherwise
      # returns :succeeded
      def process(entity, world)
        super(entity, world)

        response = :succeeded

        if nodes[0].process(entity, world).succeeded?
          response = nodes[1].process(entity, world).response
        end

        update_response(handle_response(response))

        self
      end

      protected

      def handle_response(response)
        case response
        when :failed then :failed
        when :busy then :busy
        else
          :succeeded
        end
      end

      def validate_attributes
        super

        raise ArgumentError, 'assertion_identifier nil' unless nodes[0]
        raise ArgumentError, 'guarded_identifier nil' unless nodes[1]
      end
    end
  end
end
