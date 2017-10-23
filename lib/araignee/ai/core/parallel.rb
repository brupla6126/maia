require 'core/integer'
require 'araignee/ai/core/composite'

# Module for gathering AI classes
module Ai
  module Core
    # failure policy: how many need to fail to report failure: Integer >= 0, Integer::MAX means all
    # completion policy: how many need to succeed to report success: Integer >= 0, Integer::MAX means all
    class Parallel < Composite
      # param :completion, Integer::MAX means all
      attribute :completion, Integer, default: 0
      # param :failures, Integer::MAX means all
      attribute :failures, Integer, default: 0

      protected

      def execute(entity, world)
        responses = { busy: 0, succeeded: 0, failed: 0 }

        nodes = sort(filter(children), sort_reverse)

        nodes.each do |child|
          responded = child.process(entity, world).response

          # count responses
          responses[responded] ||= 0
          responses[responded] += 1
        end

        succeeding =
          case @completion
          when 0 then false
          when Integer::MAX then responses[:succeeded] == nodes.size
          else responses[:succeeded] >= @completion
          end

        failing =
          case @failures
          when 0 then false
          when Integer::MAX then responses[:failed] == nodes.size
          else responses[:failed] >= @failures
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

      def validate_attributes
        super()

        raise ArgumentError, 'completion must be >= 0' unless completion >= 0
        raise ArgumentError, 'failures must be >= 0' unless failures >= 0

        raise ArgumentError, 'completion and failures must not equal' if completion.positive? && completion.equal?(failures)
      end
    end
  end
end
