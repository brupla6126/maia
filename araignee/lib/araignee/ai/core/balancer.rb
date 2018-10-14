require 'araignee/ai/core/composite'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A Balancer will pick one child amongst many to process.
      # It will return the picked child response if one
      # otherwise will return :failed
      class Balancer < Composite
        protected

        def execute(entity, world)
          responded = :failed

          node = pick_one(filter(children))

          responded = node.process(entity, world).response if node

          update_response(handle_response(responded))
        end

        def handle_response(responded)
          return responded if %i[busy succeeded].include?(responded)

          :failed
        end
      end
    end
  end
end
