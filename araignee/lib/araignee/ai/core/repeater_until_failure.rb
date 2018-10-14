require 'araignee/ai/core/repeater'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Like a repeater, these decorators will continue to reprocess their child.
      # That is until the child finally returns a failure, at which point the
      # repeater will return success to its parent.
      class RepeaterUntilFailure < Repeater
        def repeat(child, entity, world)
          loop do
            break if child.process(entity, world).failed?
          end
        end
      end
    end
  end
end
