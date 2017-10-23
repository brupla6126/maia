require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # A Guard Node will evaluate an interrogator node and if it returns
    # :succeeded the guard will process the guarded node.
    class Guard < Decorator
      # the interrogator node, see Ai::Core::Interrogator
      attribute :interrogator, Node, default: nil
      # child is the guarded node

      protected

      # If the interrogator node evaluates to :succeeded, the guard
      # will return the processed guarded node state, otherwise
      # returns :failed.
      def execute(entity, world)
        responded = :failed

        if interrogator.process(entity, world).succeeded?
          responded = child.process(entity, world).response
        end

        update_response(handle_response(responded))
      end

      def node_starting
        super()

        interrogator.start!
      end

      def node_stopping
        super()

        interrogator.stop!
      end

      def handle_response(responded)
        return responded if %i[busy failed].include?(responded)

        :succeeded
      end

      def validate_attributes
        super()

        raise ArgumentError, 'interrogator node nil' unless interrogator
      end
    end
  end
end
