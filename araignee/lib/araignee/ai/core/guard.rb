require 'araignee/ai/core/decorator'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A Guard Node will evaluate an interrogator node and if it returns
      # :succeeded the guard will process the guarded node.
      class Guard < Decorator
        protected

        # If the interrogator node evaluates to :succeeded, the guard
        # will return the processed guarded node state, otherwise
        # returns :failed.
        def execute(request)
          responded = :failed

          responded = child.process(request).response if interrogator.process(request).succeeded?

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
