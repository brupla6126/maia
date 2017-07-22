#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/composite'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # a sequence is an AND, requiring all children to succeed to return a success
      class Sequence < Composite
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          # select nodes
          # order nodes
          # handle result

          results = { running: 0, succeeded: 0, failed: 0 }
          nodes_processed = 0

          nodes.select { |node| node.running? || node.succeeded? }.each do |node|
            if node.succeeded?
              # do not process if it has already succeeded
              results[:succeeded] += 1
            else
              results[node.process(entity, world).state_name] += 1
            end
            nodes_processed += 1

            # no need to process further if this node is still running or has failed
            break if node.running? || node.failed?
          end

          # succeed if all children have succeeded
          fire_state_event(:success) if results[:succeeded] == nodes_processed
          # fail if one child has failed
          fire_state_event(:failure) if results[:failed].positive?

          self
        end
      end
    end
  end
end
