require 'araignee/ai/leaf'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A Condition Node will evaluate a term and process the yes node
    # if it returns true otherwise will process the no node
    class Condition < Leaf
      attribute :term, Node
      attribute :yes, Node
      attribute :no, Node

      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        case @term.process(entity, world).state_name
        when :succeeded
          executing_node = @yes
        when :failed
          executing_node = @no
        end

        handle_result(executing_node.process(entity, world).state_name) if executing_node

        self
      end

      protected

      def node_starting
        super

        @term.start!
        @yes.start!
        @no.start!
      end

      def node_stopping
        super

        @term.stop!
        @yes.stop!
        @no.stop!
      end

      def handle_result(result)
        case result
        when :succeeded then succeed!
        when :failed then failure!
        when :running then busy!
        end
      end

      def validate_attributes
        super

        raise ArgumentError, 'term nil' unless @term
        raise ArgumentError, 'yes nil' unless @yes
        raise ArgumentError, 'no nil' unless @no
      end
    end
  end
end
