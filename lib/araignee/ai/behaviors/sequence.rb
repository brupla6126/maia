require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # a sequence is a logic AND, requiring all children to succeed to return a success
    class Sequence < Composite
      def process(entity, world)
        super

        states = { busy: 0, succeeded: 0, failed: 0 }

        nodes = @nodes.select(&:running?)
        nodes = order_nodes(nodes) if respond_to?(:order_nodes)

        nodes.each do |node|
          states[node.process(entity, world).response] += 1

          # no need to process further if this node is busy or has failed
          break if node.busy? || node.failed?
        end

        response =
          # succeed if all children have succeeded
          if states[:succeeded] == nodes.count
            :succeeded
          elsif states[:failed].positive?
            :failed
          else
            :busy
          end

        update_response(response)

        self
      end
    end
  end
end
