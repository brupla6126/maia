require 'araignee/ai/core/decorator'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # An Interrogator Node will return its decorating child response
      # which can only be :succeeded or :failed.
      class Interrogator < Decorator
        protected

        def execute(request)
          responded = child.process(request).response

          update_response(handle_response(responded))
        end

        def valid_response?(response)
          %i[failed succeeded].include?(response)
        end

        # return :succeeded or :failed
        def handle_response(responded)
          return :failed unless responded.equal?(:succeeded)

          :succeeded
        end
      end
    end
  end
end
