require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # A Condition Node will evaluate a term and if it returns
    # true it will process the yes node otherwise will process
    # the no node
    class Condition < Composite
      # expects nodes[0] be the term
      # expects nodes[1] be the yes node
      # expects nodes[2] be the no node
      def initialize(attributes = {})
        super

        @term_identifier = @nodes[0].identifier
        @yes_identifier = @nodes[1].identifier
        @no_identifier = @nodes[2].identifier
      end

      def process(entity, world)
        super

        case child(@term_identifier).process(entity, world).state_name
        when :succeeded
          executing_node = child(@yes_identifier)
        when :failed
          executing_node = child(@no_identifier)
        end

        handle_result(executing_node.process(entity, world).state_name) if executing_node

        self
      end

      protected

      def handle_result(result)
        case result
        when :succeeded then succeed!
        when :failed then failure!
        when :running then busy!
        end
      end

      def validate_attributes
        super

        raise ArgumentError, 'term_identifier nil' unless @term_identifier
        raise ArgumentError, 'yes_identifier nil' unless @yes_identifier
        raise ArgumentError, 'no_identifier nil' unless @no_identifier
      end
    end
  end
end
