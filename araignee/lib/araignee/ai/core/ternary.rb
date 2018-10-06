require 'araignee/ai/core/node'

# Module for gathering AI classes
module Ai
  module Core
    # A Ternary node will process an interrogator and if it returns
    # :succeeded it will process the yes node, otherwise will process
    # the no node. It will return the response from the yes or
    # no node.
    class Ternary < Node
      attribute :interrogator, Node, default: nil
      attribute :yes, Node, default: nil
      attribute :no, Node, default: nil

      def execute(entity, world)
        executing_node = execute_node(interrogator.process(entity, world).response)

        responded = executing_node.process(entity, world).response

        update_response(handle_response(responded))
      end

      protected

      # starts the interrogator, yes and no nodes.
      def node_starting
        super()

        interrogator.start!
        yes.start!
        no.start!
      end

      # stops the interrogator, yes and no nodes.
      def node_stopping
        super()

        interrogator.stop!
        yes.stop!
        no.stop!
      end

      def execute_node(interrogator_response)
        case interrogator_response
        when :succeeded then yes
        when :failed then no
        else raise ArgumentError, "invalid response: #{interrogator_response}"
        end
      end

      def handle_response(responded)
        return responded if %i[busy failed].include?(responded)

        :succeeded
      end

      def validate_attributes
        super()

        raise ArgumentError, 'interrogator node nil' unless interrogator
        raise ArgumentError, 'yes node nil' unless yes
        raise ArgumentError, 'no node nil' unless no
      end
    end
  end
end
