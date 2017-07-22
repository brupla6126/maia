#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/leaf'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # The Timeout node FAILS after a certain amount of time has passed
      class Timeout < Leaf
        attribute :timeout, Integer, default: 0

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          @start ||= Time.now

          failure if Time.now - @start > @timeout

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

          raise ArgumentError, 'timeout must be > 0' unless @timeout.positive?
        end
      end
    end
  end
end
