require 'araignee/ai/core/decorator'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # A repeater will reexecute its child node each time its child
      # returns a result. These are often used at the very base of the
      # tree, to make the tree to run continuously. Repeaters may optionally
      # run their children a set number of times before returning to their parent.
      class Repeater < Decorator
        protected

        def execute(entity, world)
          repeat(child, entity, world)

          update_response(:succeeded)
        end

        def repeat(_child, _entity, _world) end
      end
    end
  end
end
