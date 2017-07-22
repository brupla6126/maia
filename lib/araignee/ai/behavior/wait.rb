#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/leaf'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # The Wait node SUCCEEDS after a certain amount of time has passed
      class Wait < Leaf
        attribute :wait, Integer, default: 0

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          @start ||= Time.now

          success if (Time.now - @start) > @wait

          self
        end

        def start_node
          super

          @start = Time.now
        end

        def reset_node
          super

          @start = Time.now
        end

        protected

        def validate_attributes
          super

          raise ArgumentError, 'wait must be > 0' unless @wait.positive?
        end
      end
    end
  end
end
