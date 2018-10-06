require 'virtus'
require 'araignee/ai/core/repeater'

# Module for gathering AI classes
module Ai
  module Core
    # Defines attributes and methods to repeat node
    # processing n times
    class RepeaterNumberTimes < Repeater
      attribute :times, Integer, default: 1

      def repeat(child, entity, world)
        raise ArgumentError, 'times must be > 0' unless times > 0

        child.start! unless child.running?

        (1..times).each do
          child.process(entity, world)
        end
      end
    end
  end
end
