require 'ostruct'
require 'securerandom'
require 'araignee/utils/emitter'

module Araignee
  module Ai
    module Core
      # Node Class, base class for all nodes in a tree
      class Node < OpenStruct
        include Araignee::Utils::Emitter

        def initialize(state = {})
          super(default_attributes.merge(state))

          self.identifier ||= SecureRandom.hex
        end

        def process(entity, world)
          execute(entity, world)

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

        def reset_node
          reset_attribute(:response)
        end

        def validate_attributes
          raise ArgumentError, 'invalid identifier' unless identifier.instance_of?(String)
        end

        protected

        def default_attributes
          { response: :unknown }
        end

        def reset_attribute(attribute)
          self[attribute] = default_attributes[attribute]
        end

        def update_response(response)
          raise ArgumentError, "invalid response: #{response}" unless %i[busy failed succeeded].include?(response)

          self.response = response
        end

        # Implement this method in derived classes to do the node's behavior.
        def execute(_entity, _world) end
      end
    end
  end
end
