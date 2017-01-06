module Araignee
  module Architecture
    # Finder finds an entity(ies)
    class Finder
      attr_reader :filters

      def self.execute(filters)
        new(filters).find
      end

      def initialize(filters)
        @filters = filters
      end

      def find
        raise NotImplementedError
      end

      # Result class for Finder
      class Result
        attr_reader :entity, :messages

        def initialize(entity, messages = [])
          @entity = entity
          @messages = messages
        end

        def successful?
          @messages.empty?
        end
      end
    end
  end
end
