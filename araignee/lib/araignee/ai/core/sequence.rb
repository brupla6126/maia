require 'araignee/ai/core/composite'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A Sequence node is a logic AND, requiring all children to succeed to
      # return response :succeeded
      class Sequence < Composite
        protected

        def execute(entity, world)
          responses = initialize_responses

          nodes.each do |node|
            respond(responses, node.process(entity, world).response)
            # no need to execute further if this node is busy or has failed
            break if node.busy? || node.failed?
          end

          update_response(handle_response(nodes, responses))
        end

        def initialize_responses
          { busy: 0, failed: 0, succeeded: 0 }
        end

        def respond(responses, responded)
          responses[responded] += 1
        end

        def handle_response(nodes, responses)
          # succeed if all children have succeeded
          if responses.fetch(:succeeded).equal?(nodes.count)
            :succeeded
          elsif responses.fetch(:failed).positive?
            :failed
          else
            :busy
          end
        end
      end
    end
  end
end
