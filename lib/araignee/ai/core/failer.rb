require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # A failer's returned response is always :failed, irrespective of what the
    # child node actually returned. These are useful in cases where you want to
    # execute a branch of a tree where a :success is expected or anticipated,
    # but you do not want to abandon executing of a sequence that branch
    # sits on.
    class Failer < Decorator
      # see Ai::Core::Node#execute
      def execute(entity, world)
        child.process(entity, world)

        update_response(:failed)
      end
    end
  end
end
