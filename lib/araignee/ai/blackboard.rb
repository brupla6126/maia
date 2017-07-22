#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/utils/log'

# Module for gathering AI classes
module Araignee::AI
  # represents a "memory" in an agent and is required to run a BehaviorTree
  class BlackBoard
    # attributes {weight: 20}
    def initialize(attributes = {})
      super

      self
    end

    def process(entity, world)
      super

      self
    end
  end
end
