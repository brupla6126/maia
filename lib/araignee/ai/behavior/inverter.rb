#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Inverter will invert or negate the result of their child node.
      # Success becomes failure, and failure becomes success.
      class Inverter < Decorator
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          @node.process(entity, world)

          fire_state_event(:failure) if @node.succeeded?
          fire_state_event(:success) if @node.failed?

          self
        end

        protected

        def validate_attributes
          super

          raise ArgumentError, ':node must be set' unless @node
        end
      end
    end
  end
end
