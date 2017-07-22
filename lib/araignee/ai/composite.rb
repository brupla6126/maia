#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module for gathering AI classes
module Araignee::AI
  # A Composite Node Class, based on the Composite Design Pattern
  class Composite < Node
    attribute :nodes, Array, default: []

    def initialize(attributes = {})
      super

      self
    end

    # add, insert
    def add_node(node, index = :last)
      if index == :last
        @nodes << node
      else
        @nodes.insert_at(index, node)
      end
    end

    def remove_node(node)
      @nodes.delete node
    end

    def start_node
      super

      # puts "starting decorating node: #{@node.inspect}"
      @nodes.each { |node| node.fire_state_event(:start) }
    end

    def reset_node
      super

      # reset decorating node
      @nodes.each(&:reset_node)
    end

    # def count
    #   @nodes.size
    # end

    protected

    def validate_attributes
      super

      raise ArgumentError, 'must have at least one child node' if @nodes.empty?
    end
  end
end
