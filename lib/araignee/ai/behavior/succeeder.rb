#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # A succeeder will always return success, irrespective of what the child node actually returned. These are useful in cases where you want to process a branch of a tree where a failure is expected or anticipated, but you do not want to abandon processing of a sequence that branch sits on
      class Succeeder < Decorator
        def initialize(attributes = {})
          super
        end

        def process(entity, world)
          super

          @node.process(entity, world) if @node.running?

          fire_state_event(:success)

          self
        end
      end
    end
  end
end
