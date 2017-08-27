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
        super

        running = 0
        succeeded = 0

        nodes = @nodes.select(&:active?)
        nodes = order_nodes(nodes) if respond_to?(:order_nodes)

        nodes.each do |node|
          case node.process(entity, world).state_name
          when :running
            running += 1
          when :succeeded
            succeeded += 1
            break
          end
        end

        if succeeded > 0
          succeed!
        elsif running > 0
          busy!
        else
          failure!
        end

        self
      end
    end
  end
end
