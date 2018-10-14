require 'araignee/ai/core/node'

# Module for gathering AI classes
module Ai
  module Core
    # A Decorator Node Class, based on the Decorator Design Pattern
    class Decorator < Node
      protected

      def default_attributes
        super().merge(
          child: nil
        )
      end

      def validate_attributes
        raise ArgumentError, 'invalid decorated child' unless child
      end
    end
  end
end
