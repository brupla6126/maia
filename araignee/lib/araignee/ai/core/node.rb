require 'ostruct'
require 'araignee/utils/emitter'

module Araignee
  module Ai
    module Core
      # Node Class, base class for all nodes in a tree
      class Node < OpenStruct
        include Araignee::Utils::Emitter

        def initialize(state = {})
          super(default_attributes.merge(state))
        end

        def process(entity, world)
          emit(:ai_node_processing, self)

          execute(entity, world)

          emit(:ai_node_processed, self)

          self
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

        def reset
          reset_attribute(:response)

          self
        end

        protected

        def default_attributes
          { response: :unknown }
        end

        def reset_attribute(attribute)
          self[attribute] = default_attributes[attribute]
        end

        # Implement this method in derived classes to do the node's behavior.
        def execute(_entity, _world) end

        def update_response(response)
          raise ArgumentError, "invalid response: #{response}" unless %i[busy failed succeeded].include?(response)

          self.response = response
        end
      end
    end
  end
end
