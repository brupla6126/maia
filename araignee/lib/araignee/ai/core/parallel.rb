require 'core/integer'
require 'araignee/ai/core/composite'

module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # failure policy: how many need to fail to report failure: Integer >= 0, Integer::MAX means all
      # completion policy: how many need to succeed to report success: Integer >= 0, Integer::MAX means all
      class Parallel < Composite
        protected

        def execute(entity, world)
          raise ArgumentError, 'completions must be >= 0' unless completions >= 0
          raise ArgumentError, 'failures must be >= 0' unless failures >= 0

          raise ArgumentError, 'completions and failures must not equal' if completions.positive? && completions.equal?(failures)

          responses = { busy: 0, succeeded: 0, failed: 0 }

          nodes = sort(filter(children), sort_reversed)

          nodes.each do |child|
            responded = child.process(entity, world).response

            # count responses
            responses[responded] ||= 0
            responses[responded] += 1
          end

          succeeding =
            case completions
            when 0 then false
            when Integer::MAX then responses[:succeeded] == nodes.size
            else responses[:succeeded] >= completions
            end

          failing =
            case failures
            when 0 then false
            when Integer::MAX then responses[:failed] == nodes.size
            else responses[:failed] >= failures
            end

          responded =
            if succeeding
              :succeeded
            elsif failing
              :failed
            else
              :busy
            end

          update_response(responded)
        end
      end
    end
  end
end
