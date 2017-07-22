#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/composite'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Class TermXor
      class TermXor < Composite
        # Creates a new instance of TermXor
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          results = { succeeded: 0 }

          @nodes.select(&:running?).each do |node|
            case node.process(entity, world).state_name
            when :succeeded
              results[:succeeded] += 1
            end
          end

          results[:succeeded] == 1 ? fire_state_event(:success) : fire_state_event(:failure)

          self
        end

        protected

        def validate_attributes
          super

          # raise ArgumentError, ':nodes must be set' unless nodes
        end
      end
    end
  end
end
