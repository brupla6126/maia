#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/composite'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Random selectors pick one of their child nodes randomly
      module OrderRandom
        def order_nodes(nodes, _reverse = false)
          nodes.shuffle
        end
      end
    end
  end
end
