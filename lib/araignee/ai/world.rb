#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # World Class, base class for all nodes in the behavior tree
    class World # < Decorator
      def initialize
        super
        # verify
      end

      def process(entity, world)
        raise ArgumentError, 'entity nil' unless entity

        @elapsed += world.delta

        self
      end

      def delta
      end

      def get_entity(tag)
      end

      def get_entities(group)
      end
    end
  end
end
