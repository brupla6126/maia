require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Class Xor
    class Xor < Composite
      def process(entity, world)
        super(entity, world)

        succeeded = 0

        busy = false
        nodes.each do |node|
          case node.process(entity, world).response
          when :busy
            busy = true
            break
          when :succeeded
            succeeded += 1
          end
        end

        response =
          if busy
            :busy
          elsif succeeded == 1
            :succeeded
          else
            :failed
          end

        update_response(response)

        self
      end
    end
  end
end
