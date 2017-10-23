require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # A Starter node will stop its child node.
    # Will always set its response to :succeeded
    class Stopper < Decorator
      def execute(_entity, _world)
        child.stop! if child.can_stop?

        update_response(:succeeded)
      end
    end
  end
end
