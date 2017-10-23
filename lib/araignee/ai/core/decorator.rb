require 'araignee/ai/core/node'

# Module for gathering AI classes
module Ai
  module Core
    # A Decorator Node Class, based on the Decorator Design Pattern
    class Decorator < Node
      attribute :child, Node, default: nil
      attribute :start_child, Boolean, default: true
      attribute :stop_child, Boolean, default: true

      protected

      def node_starting
        super()

        child.start! if start_child
      end

      def node_stopping
        super()

        child.stop! if stop_child
      end

      def validate_attributes
        raise ArgumentError, 'invalid decorating child' unless child
      end
    end
  end
end
