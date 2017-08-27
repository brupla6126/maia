require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Class Xor
    class Xor < Composite
      def process(entity, world)
        super

        succeeded = 0

        running = false
        @nodes.each do |node|
          case node.process(entity, world).state_name
          when :running
            running = true
            break
          when :succeeded
            succeeded += 1
          end
        end

        if running
          busy!
        else
          succeeded == 1 ? succeed! : failure!
        end

        self
      end

      protected

      def validate_attributes
        super

        raise ArgumentError, 'must have at least one child node' if @nodes.empty?
      end
    end
  end
end
