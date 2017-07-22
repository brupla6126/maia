#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module for gathering AI classes
module Araignee::AI
  # A Decorator Node Class, based on the Decorator Design Pattern
  class Decorator < Node
    attribute :node, Node, default: nil

    def initialize(attributes = {})
      super

      self
    end

    def node=(new_node)
      raise ArgumentError, 'new_node nil' unless new_node

      @node.cancel if @node&.running?

      super new_node
    end

    def start_node
      super

      @node.fire_state_event(:start)
    end

    def reset_node
      super

      # reset decorating node
      @node.reset_node
    end

    protected

    def validate_attributes
      super

      raise ArgumentError, 'node nil' unless @node
    end
  end
end
