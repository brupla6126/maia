require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # a sequence is a logic AND, requiring all children to succeed to return a success
    class Sequence < Composite
      def process(entity, world)
        super

        states = { running: 0, succeeded: 0, failed: 0 }

        nodes = @nodes.select(&:active?)
        nodes = order_nodes(nodes) if respond_to?(:order_nodes)

        nodes.each do |node|
          states[node.process(entity, world).state_name] += 1

          # no need to process further if this node is still running or has failed
          break if node.running?
        end

        # succeed if all children have succeeded
        if states[:succeeded] == nodes.count
          succeed!
        elsif states[:failed].positive?
          failure!
        else
          busy!
        end

        self
      end
    end
  end
end
