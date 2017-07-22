#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Max Time limits the maximum time its child can be running. If the child does not complete its execution before the maximum time, the child task is canceled and a failure is returned
      class Expiration < Decorator
        attribute :expires, Integer, default: 0

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          @start ||= Time.now
          @elapsed = Time.now - @start

          # Log.debug { "elapsed: #{@elapsed}, expires: #{expires}" }
          if @elapsed <= @expires
            succeed if @node.process(entity, world).succeeded?
          else
            Log.debug { "#{self.class} Elapsed..." }

            @node.fire_state_event(:cancel)

            fire_state_event(:failure)
          end

          self
        end

        def start_node
          super

          @start = Time.now
        end

        def reset_node
          super

          @elapsed = 0
          @start = Time.now
        end

        protected

        def validate_attributes
          super

          raise ArgumentError, ':expires must be > 0' unless @expires.positive?
        end
      end
    end
  end
end
