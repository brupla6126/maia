#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # This decorator imposes a times number of calls its child can have within the whole execution of the Behavior Tree, i.e., after a certain number of calls, its child will never be count again.
      class Limiter < Decorator
        attribute :count, Integer, default: 0, writer: :private
        attribute :times, Integer, default: 1

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          # Log.debug { "count: #{count}, times: #{times}" }

          if @count < @times
            @count += 1

            @node.process(entity, world)

            fire_state_event(:failure) if @node.failed?
            fire_state_event(:success) if @node.succeeded?
          else
            failure
          end

          self
        end

        protected

        def validate_attributes
          super

          raise ArgumentError, 'times must be > 0' unless @times.positive?
        end
      end
    end
  end
end
