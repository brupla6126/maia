module Araignee
  module Architecture
    # Class for global access to helpers
    class Repository
      def self.register(context, type = nil, helper = nil)
        helpers[context] ||= {}

        if type && helper
          helpers[context][type] = helper
        else
          context_helpers = {}
          yield context_helpers

          helpers[context].merge!(context_helpers)
        end
      end

      def self.for(context, type)
        helpers[context][type] if helpers[context]
      end

      def self.helpers
        @helpers ||= {}
      end

      def self.count
        helpers.reduce(0) { |acc, (_k, v)| acc + v.count }
      end

      def self.clean
        @helpers = {}
      end
    end
  end
end
