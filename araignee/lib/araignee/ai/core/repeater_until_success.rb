require 'araignee/ai/core/repeater'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Like a repeater, these decorators will continue to reprocess their child.
      # That is until the child finally returns a success, at which point the
      # repeater will return success to its parent.
      class RepeaterUntilSuccess < Repeater
        protected

        def repeat(child, request)
          loop do
            break if child.process(request).succeeded?
          end
        end
      end
    end
  end
end
