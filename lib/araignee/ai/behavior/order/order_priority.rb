#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Priority selectors are simply an ordered list of behaviors that are tried
      # one after the other until one matches.
      module OrderPriority
        def order_nodes(nodes, reverse = false)
          nodes.sort_by(&:priority)
          nodes.reverse if reverse

          nodes
        end
      end
    end
  end
end
