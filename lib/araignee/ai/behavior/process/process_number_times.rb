#!/usr/bin/env ruby
# encoding: utf-8

require 'virtus'
require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      module ProcessChildNumberTimes
        include Virtus.model

        attribute :times, Integer, default: 0

        def repeat_process(entity, world)
          raise ArgumentError, 'times must be > 0' unless @times.positive?

          @count ||= 0

          loop do
            @node.start unless @node.running?
            @node.process(entity, world)

            break unless @node.succeeded? || @node.failed?
            @count += 1

            if @times != :infinity && @count >= @times
              # failure
              break
            end
          end

          @node.succeeded? && fire_state_event(:success)
          @node.failed? && fire_state_event(:failure)

          self
        end
      end
    end
  end
end
