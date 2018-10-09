require 'araignee/ai/core/node'

module Ai
  module Core
    class NodeBusy < Node
      def process(_entity, _world)
        update_response(:busy)

        self
      end
    end

    class NodeFailed < Node
      def process(_entity, _world)
        update_response(:failed)

        self
      end
    end

    class NodeSucceeded < Node
      def process(_entity, _world)
        update_response(:succeeded)

        self
      end
    end

    class InterrogatorFailed < Node
      def process(_entity, _world)
        update_response(:failed)

        self
      end
    end

    class InterrogatorSucceeded < Node
      def process(_entity, _world)
        update_response(:succeeded)

        self
      end
    end
  end
end
