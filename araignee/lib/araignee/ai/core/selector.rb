require 'araignee/ai/core/composite'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # selector will return a success if any of its children succeed and not
      # execute any further children. It will execute the first child, and if
      # it fails will execute the second, and if that fails will execute the
      # third, until a success is reached, at which point it will instantly return
      # success. It will fail if all children fail. This means a selector is
      # analagous with an OR gate, and as a conditional statement can be used to
      # check multiple conditions to see if any one of them is true.
      class Selector < Composite
        protected

        def execute(entity, world)
          responses = initialize_responses

          nodes = prepare_nodes(children, sort_reverse)

          nodes.each do |node|
            respond(responses, node.process(entity, world).response)
          end

          update_response(handle_response(responses))
        end

        def initialize_responses
          { busy: 0, failed: 0, succeeded: 0 }
        end

        def prepare_nodes(nodes, sort_reversed)
          sort(filter(nodes), sort_reversed)
        end

        def respond(responses, responded)
          responses[responded] += 1
        end

        def handle_response(responses)
          # succeed if all children have succeeded
          if responses.fetch(:busy).positive?
            :busy
          elsif responses.fetch(:succeeded).positive?
            :succeeded
          else
            :failed
          end
        end
      end
    end
  end
end
