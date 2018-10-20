require 'araignee/ai/core/decorator'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A Guard Node will evaluate an interrogator node and if it returns
      # :succeeded the guard will process the guarded node.
      class Guard < Decorator
        protected

        def default_attributes
          super().merge(
            interrogator: nil # the interrogator node, see Ai::Core::Interrogator
            # child is the guarded node
          )
        end

        # If the interrogator node evaluates to :succeeded, the guard
        # will return the processed guarded node state, otherwise
        # returns :failed.
        def execute(entity, world)
          responded = :failed

          responded = child.process(entity, world).response if interrogator.process(entity, world).succeeded?

          update_response(handle_response(responded))
        end

        def handle_response(responded)
          return responded if %i[busy failed].include?(responded)

          :succeeded
        end
      end
    end
  end
end
