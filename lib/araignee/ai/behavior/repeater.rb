#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'
require 'araignee/ai/behavior/process/process_number_times'
require 'araignee/ai/behavior/process/process_until_failure'
require 'araignee/ai/behavior/process/process_until_success'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # A repeater will reprocess its child node each time its child
      # returns a result. These are often used at the very base of the
      # tree, to make the tree to run continuously. Repeaters may optionally
      # run their children a set number of times before returning to their parent
      class Repeater < Decorator
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          Log[self.class].debug { "node: #{@node.inspect}" }

          repeat_process(entity, world) if @node.running?

          self
        end
      end
    end
  end
end
