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
      class SelectorTask < Composite
        def process_by_task(entity, world)
          super

          unless @current
            # run a random node
            @current = nodes.sample
          end

          case @current.process(entity, world)
          when :succeeded then
            success
            @current = nil
          when :failed then
            failure
            @current = nil
          end
        end

        self
      end
    end
  end
end
