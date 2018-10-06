require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # A succeeder will always return success, irrespective of what
    # the child node actually returned. These are useful in cases where
    # you want to execute a branch of a tree where a failure is expected or
    # anticipated, but you do not want to abandon executing a sequence
    # that branch sits on
    class Succeeder < Decorator
      def execute(entity, world)
        child.process(entity, world)

        update_response(:succeeded)
      end
    end
  end
end
