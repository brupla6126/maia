#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/leaf'
require 'araignee/ai/decision/term'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # Class for a Condition Node
      class Condition < Leaf
        attribute :term, Node
        attribute :yes, Node
        attribute :no, Node

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          case @term.process(entity, world).state_name
          when :succeeded
            send_event(@yes.process(entity, world).state_name)
          when :failed
            send_event(@no.process(entity, world).state_name)
          end

          self
        end

        def start_node
          super

          @term.fire_state_event(:start)
          @yes.fire_state_event(:start)
          @no.fire_state_event(:start)
        end

        protected

        def validate_attributes
          super

          raise ArgumentError, 'term nil' unless @term
          raise ArgumentError, 'yes nil' unless @yes
          raise ArgumentError, 'no nil' unless @no
        end
      end
    end
  end
end
