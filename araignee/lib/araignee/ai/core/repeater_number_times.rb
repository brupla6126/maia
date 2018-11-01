require 'araignee/ai/core/repeater'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Defines attributes and methods to repeat node
      # processing n times
      class RepeaterNumberTimes < Repeater
        protected

        def repeat(child, entity, world)
          raise ArgumentError, 'times must be > 0' unless state.times.positive?

          child.start! unless child.running?

          (1..state.times).each do
            child.process(entity, world)
          end
        end
      end
    end
  end
end
