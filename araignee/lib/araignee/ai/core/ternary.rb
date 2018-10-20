require 'araignee/ai/core/node'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A Ternary node will process an interrogator and if it returns
      # :succeeded it will process the yes node, otherwise will process
      # the no node. It will return the response from the yes or
      # no node.
      class Ternary < Node
        protected

        def default_attributes
          super().merge(
            interrogator: nil, # Ai::Core::Node
            yes: nil, # Ai::Core::Node
            no: nil # Ai::Core::Node
          )
        end

        def execute(entity, world)
          executing_node = execute_node(interrogator.process(entity, world).response)

          responded = executing_node.process(entity, world).response

          update_response(handle_response(responded))
        end

        def execute_node(interrogator_response)
          case interrogator_response
          when :succeeded then yes
          when :failed then no
          else raise ArgumentError, "invalid response: #{interrogator_response}"
          end
        end

        def handle_response(responded)
          return responded if %i[busy failed].include?(responded)

          :succeeded
        end
      end
    end
  end
end
