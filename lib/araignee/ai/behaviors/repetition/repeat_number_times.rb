require 'virtus'
require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    module Repetition
      # Defines attributes and methods to repeat node
      # processing n times
      module RepeatNumberTimes
        include Virtus.module

        attribute :times, Integer, default: 0

        def repeat_process(entity, world)
          raise ArgumentError, 'times must be >= 0' unless @times >= 0

          @count ||= 0

          loop do
            @node.start! unless @node.started?
            @node.process(entity, world)

            break unless @node.succeeded? || @node.failed?
            @count += 1

            if @times != :infinity && @count >= @times
              # failure
              break
            end
          end

          succeed!

          self
        end
      end
    end
  end
end
