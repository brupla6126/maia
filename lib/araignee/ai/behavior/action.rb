#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/leaf'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Action
      class Action < Leaf
        def initialize(attributes = {})
          super

          self
        end
      end
    end
  end
end
