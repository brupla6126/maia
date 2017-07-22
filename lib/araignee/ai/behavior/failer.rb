#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # A failer will always return failure, irrespective of what the child node actually returned. These are useful in cases where you want to process a branch of a tree where a success is expected or anticipated, but you do not want to abandon processing of a sequence that branch sits on
      class Failer < Decorator
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          @node.process(entity, world) if @node.running?

          fire_state_event(:failure)

          self
        end
      end
    end
  end
end
