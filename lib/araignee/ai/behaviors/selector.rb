require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # selector will return a success if any of its children succeed and not
    # process any further children. It will process the first child, and if
    # it fails will process the second, and if that fails will process the
    # third, until a success is reached, at which point it will instantly return
    # success. It will fail if all children fail. This means a selector is
    # analagous with an OR gate, and as a conditional statement can be used to
    # check multiple conditions to see if any one of them is true.
    class Selector < Composite
      def process(entity, world)
        super(entity, world)

        busy = 0
        succeeded = 0

        nodes_selected = nodes.select(&:running?)
        nodes_selected = order_nodes(nodes_selected) if respond_to?(:order_nodes)

        nodes_selected.each do |node|
          case node.process(entity, world).response
          when :busy
            busy += 1
          when :succeeded
            succeeded += 1
            break
          end
        end

        response =
          if succeeded > 0
            :succeeded
          elsif busy > 0
            :busy
          else
            :failed
          end

        update_response(response)

        self
      end
    end
  end
end
