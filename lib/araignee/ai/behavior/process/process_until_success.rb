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
      module ProcessChildUntilSuccess
        def repeat_process(entity, world)
          loop do
            Log[self.class].debug { "node1: #{@node.attributes}" }

            @node.failed? && @node.fire_state_event(:start)

            break if @node.process(entity, world).succeeded?
            Log[self.class].debug { "node4: #{@node.attributes}" }
          end

          fire_state_event(:success)

          self
        end
      end
    end
  end
end
