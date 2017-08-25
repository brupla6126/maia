require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # a sequence is a logic AND, requiring all children to succeed to return a success
    class Sequence < Composite
      def process(entity, world)
        super

        # select nodes
        # order nodes
        # handle result

        stats = { running: 0, succeeded: 0, failed: 0 }
        nodes_processed = 0

        nodes = @nodes.select { |node| node.running? || node.succeeded? }
        nodes = order_nodes(nodes) if respond_to?(:order_nodes)

        nodes.each do |node|
          if node.succeeded?
            # do not process but count if it has already succeeded
            stats[:succeeded] += 1
          else
            stats[node.process(entity, world).state_name] += 1
          end

          nodes_processed += 1

          # no need to process further if this node is still running or has failed
          break if node.running? || node.failed?
        end

        # succeed if all children have succeeded
        fire_state_event(:success) if stats[:succeeded] == nodes_processed
        # fail if one child has failed
        fire_state_event(:failure) if stats[:failed].positive?

        self
      end
    end
  end
end
