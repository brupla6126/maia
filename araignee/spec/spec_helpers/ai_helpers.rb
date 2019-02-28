require 'ostruct'
require 'araignee/ai/core/node'

def initial_state(defaults = {})
  OpenStruct.new({ response: :unknown, a: 1, b: 2, c: 3 }.merge(defaults))
end

def initialize_state(node, defaults = {})
  node.on(:ai_node_processing) do |params|
    emitter = params[0]
    emitter.state = initial_state(defaults)
  end
end

def busy_state
  OpenStruct.new(response: :busy, a: 1, b: 4, c: 3, d: 2)
end

def failed_state
  OpenStruct.new(response: :failed, a: 1, b: 4, c: 3, d: 2)
end

def succeeded_state
  OpenStruct.new(response: :succeeded, a: 1, b: 4, c: 3, d: 2)
end

module Araignee
  module Ai
    module Helpers
      class NodeBusy < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:busy)

          self
        end
      end

      class NodeFailed < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:failed)

          self
        end
      end

      class NodeSucceeded < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:succeeded)

          self
        end
      end

      class InterrogatorFailed < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:failed)

          self
        end
      end

      class InterrogatorSucceeded < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:succeeded)

          self
        end
      end

      class InterrogatorBusy < Araignee::Ai::Core::Node
        def execute(_request)
          update_response(:busy)

          self
        end
      end
    end
  end
end
