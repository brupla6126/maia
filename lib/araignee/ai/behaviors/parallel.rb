require 'core/integer'
require 'araignee/ai/composite'

# Module for gathering AI classes
module AI
  # Module for gathering Behavior Tree classes
  module Behaviors
    # failure policy: how many need to fail to report failure: Integer >= 0, Integer::MAX means all
    # completion policy: how many need to succeed to report success: Integer >= 0, Integer::MAX means all
    class Parallel < Composite
      attribute :completion, Integer, default: 0
      attribute :failures, Integer, default: 0

      # param attributes Hash :completion, Integer::MAX means all
      # param attributes Hash :failures, Integer::MAX means all
      def initialize(attributes = {})
        super
      end

      def process(entity, world)
        super

        states = { running: 0, succeeded: 0, failed: 0 }

        @nodes.each do |node|
          state = node.process(entity, world).state_name

          # count states
          states[state] ||= 0
          states[state] += 1
        end

        succeeding =
          case @completion
          when 0 then false
          when Integer::MAX then states[:succeeded] == nodes.size
          else states[:succeeded] >= @completion
          end

        failing =
          case @failures
          when 0 then false
          when Integer::MAX then states[:failed] == nodes.size
          else states[:failed] >= @failures
          end

        if succeeding
          succeed!
        elsif failing
          failure!
        else
          busy!
        end

        self
      end

      protected

      def validate_attributes
        super

        raise ArgumentError, 'completion must be >= 0' unless @completion >= 0
        raise ArgumentError, 'failures must be >= 0' unless @failures >= 0

        raise ArgumentError, 'completion and failures must not equal' if @completion.positive? && @completion == @failures
      end
    end
  end
end
