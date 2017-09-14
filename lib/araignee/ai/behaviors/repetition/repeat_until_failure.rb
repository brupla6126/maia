# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behavior
    module Repetition
      # Like a repeater, these decorators will continue to reprocess their child. That is until the child finally returns a failure, at which point the repeater will return success to its parent
      module RepeatUntilFailure
        def repeat_process(entity, world)
          loop do
            @node.succeeded? && @node.start!

            break if @node.process(entity, world).failed?
          end

          update_response(:succeeded)

          self
        end
      end
    end
  end
end
