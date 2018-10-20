require 'araignee/ai/core/node'

module Araignee
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
      end
    end
  end
end
