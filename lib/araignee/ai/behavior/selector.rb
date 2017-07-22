#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/composite'
require 'araignee/ai/behavior/process/process_number_times'
require 'araignee/ai/behavior/process/process_until_failure'
require 'araignee/ai/behavior/process/process_until_success'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Behavior Tree classes
    module Behavior
      # selector will return a success if any of its children succeed and not
      # process any further children. It will process the first child, and if
      # it fails will process the second, and if that fails will process the
      # third, until a success is reached, at which point it will instantly return
      # success. It will fail if all children fail. This means a selector is
      # analagous with an OR gate, and as a conditional statement can be used to
      # check multiple conditions to see if any one of them is true.
      class Selector < Composite
        def initialize(attributes = {})
          super

          self
        end

        def process(entity, world)
          super

          results = { failed: 0 }
          nodes_processed = 0

          nodes = @nodes.select(&:running?)
          nodes = order_nodes(nodes) if respond_to? :order_nodes

          nodes.each do |node|
            case node.process(entity, world).state_name
            when :succeeded
              fire_state_event(:success)
              break
            when :failed
              results[:failed] += 1
            end

            nodes_processed += 1
          end

          # fail if all children nodes have failed
          fire_state_event(:failure) if results[:failed] == nodes_processed

          self
        end
      end
    end
  end
end
