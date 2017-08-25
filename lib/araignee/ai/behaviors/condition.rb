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
          send_event(@yes.process(entity, world).state_name)
        when :failed
          send_event(@no.process(entity, world).state_name)
        end

        self
      end

      def start_node
        super

        @term.fire_state_event(:start)
        @yes.fire_state_event(:start)
        @no.fire_state_event(:start)
      end

      protected

      def validate_attributes
        super

        raise ArgumentError, 'term nil' unless @term
        raise ArgumentError, 'yes nil' unless @yes
        raise ArgumentError, 'no nil' unless @no
      end
    end
  end
end
