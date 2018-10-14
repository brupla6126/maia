require 'araignee/ai/core/composite'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Class Xor
      class Xor < Composite
        protected

        def execute(entity, world)
          responses = initialize_responses

          nodes = prepare_nodes(children)

          nodes.each do |child|
            respond(responses, child.process(entity, world).response)

            break if responses[:busy].positive?
          end

          update_response(handle_response(responses))
        end

        def initialize_responses
          { busy: 0, failed: 0, succeeded: 0 }
        end

        def prepare_nodes(nodes)
          filter(nodes)
        end

        def respond(responses, responded)
          responses[responded] += 1
        end

        # Returned response will be :busy if there is a child node busy. If not,
        # response will be :succeeded if only one child node succeeded. Otherwise
        # response will be :failed.
        def handle_response(responses)
          if responses[:busy].positive?
            :busy
          elsif responses[:succeeded].equal?(1)
            :succeeded
          else
            :failed
          end
        end
      end
    end
  end
end
