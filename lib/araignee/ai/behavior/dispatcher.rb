#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/composite'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Task selectors pick one of their child nodes based on a task or object id.
      class Dispatcher < Composite
        def process_by_task(entity, world)
          super

          unless @current
            # run a random node
            @current = @nodes.sample
          end

          case @current.process(entity, world).state_name
          when :succeeded then
            fire_state_event(:success)
            @current = nil
          when :failed then
            fire_state_event(:failure)
            @current = nil
          end
        end

        self
      end
    end
  end
end
