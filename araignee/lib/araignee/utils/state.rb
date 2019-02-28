require 'araignee/utils/emitter'

module Araignee
  module Utils
    class State
      include Araignee::Utils::Emitter

      attr_reader :context

      def initialize(context)
        @context = context
      end

      # called when entering the state
      def enter
        emit(:state_entering, self)
      end

      # called when pausing the state
      def pause
        emit(:state_pausing, self)
      end

      # called when resuming the state
      def resume
        emit(:state_resuming, self)
      end

      # called when leaving the state
      def leave
        emit(:state_leaving, self)
      end
    end
  end
end
