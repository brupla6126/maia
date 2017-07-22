#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # A Leaf Node Class, does not have any children. It is usually an Action.
    class Leaf < Node
      def initialize(attributes = {})
        super

        self
      end
    end
  end
end
