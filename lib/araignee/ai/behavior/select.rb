#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/decorator'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # see https://www.youtube.com/watch?v=lcN-hRux4cU
      class Select < Decorator
        attribute :type, Integer, default: 0
        attribute :options, Hash, default: {}
        attribute :index, Integer, default: 0
        attribute :output, Integer, default: 0

        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          # if @times < @attributes[:times]
          #  @times += 1

          #  send(@node.process(entity, world))
          # else
          #  failure
          # end

          self
        end

        protected

        def validate_attributes
          super

          # raise ArgumentError, ':type must be :all or a Integer' unless completion_policy == :all
          # raise ArgumentError, ':options invalid, must be >= 0' unless completion_policy.positive?
          # raise ArgumentError, ':index must be :all or a Integer' unless failure_policy == :all
          # raise ArgumentError, ':output invalid, must be >= 0' unless failure_policy.positive?
        end
      end
    end
  end
end
