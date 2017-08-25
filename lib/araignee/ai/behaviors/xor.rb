require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # Class Xor
    class Xor < Composite
      def process(entity, world)
        super

        stats = { succeeded: 0 }

        @nodes.select(&:running?).each do |node|
          case node.process(entity, world).state_name
          when :succeeded
            stats[:succeeded] += 1
          end
        end

        stats[:succeeded] == 1 ? fire_state_event(:success) : fire_state_event(:failure)

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
