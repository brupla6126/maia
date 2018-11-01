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

        def process(entity, world)
          emit(:ai_node_processing, self)

          execute(entity, world)

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
        def execute(_entity, _world) end

        def update_response(response)
          raise ArgumentError, "invalid response: #{response}" unless %i[busy failed succeeded].include?(response)

          state.response = response
        end
      end
    end
  end
end
