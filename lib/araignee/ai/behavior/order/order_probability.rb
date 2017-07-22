#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Probability selectors pick one of their child nodes randomly
      # based on the weights provided by the designer
      module OrderProbability
        def order_nodes(nodes, reverse = false)
          nodes.sort_by(&:weight)
          nodes.reverse if reverse

          nodes
        end
      end
    end
  end
end
