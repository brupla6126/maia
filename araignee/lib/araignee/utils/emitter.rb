module Araignee
  module Utils
    module Emitter
      def on(event, &block)
        subs = subscriptions(event)
        subs << block if block

        self
      end

      def emit(event, *params)
        subscriptions(event).each do |block|
          block.call(params)
        end
      end

      private

      def subscriptions(event)
        @subscriptions ||= {}
        @subscriptions[event] ||= []
      end
    end
  end
end
