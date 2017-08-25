# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behavior
    module Repetition
      module RepeatUntilSuccess
        def repeat_process(entity, world)
          loop do
            # restart node if failed before
            @node.failed? && @node.fire_state_event(:start)

            break if @node.process(entity, world).succeeded?
          end

          fire_state_event(:success)

          self
        end
      end
    end
  end
end
