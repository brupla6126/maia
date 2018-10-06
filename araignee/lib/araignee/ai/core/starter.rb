require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # A Starter node will first try to resume its child node
    # if it is paused. If not, it will start its child node.
    # Will always set its response to :succeeded
    class Starter < Decorator
      def execute(_entity, _world)
        child.resume! if child.paused?

        child.start! unless child.running?

        update_response(:succeeded)
      end
    end
  end
end
