require 'ostruct'
require 'araignee/utils/emitter'

module Araignee
  module Ai
    module Core
      # Node Class, base class for all nodes in a tree
      class Node < OpenStruct
        include Araignee::Utils::Emitter

        def initialize(attributes = {})
          super(attributes)
        end

        def process(request)
          emit(:ai_node_processing, self)

          execute(request)

          emit(:ai_node_processed, self)

          self
        end

        def reset
          emit(:ai_node_resetting, self)
        end

        def response
          state.response
        end

        def busy?
          response.equal?(:busy)
        end

        def failed?
          response.equal?(:failed)
        end

        def succeeded?
          response.equal?(:succeeded)
        end

        protected

        # Implement this method in derived classes to do the node's behavior.
        def execute(_request) end

        def valid_response?(response)
          %i[busy failed succeeded].include?(response)
        end

        def update_response(response)
          raise ArgumentError, "invalid response: #{response}" unless valid_response?(response)

          state.response = response
        end
      end
    end
  end
end
