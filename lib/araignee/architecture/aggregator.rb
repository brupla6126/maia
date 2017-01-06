module Araignee
  module Architecture
    # Aggregator aggregate data from entities
    class Aggregator
      attr_reader :attributes

      def self.execute(attributes)
        new(attributes).create
      end

      def initialize(attributes)
        @attributes = attributes
      end

      def create
        raise NotImplementedError
      end

      # Result class for Aggregator
      class Result
        attr_reader :entity, :messages

        def initialize(entity, messages = [])
          @entity = entity
          @messages = messages
        end

        def successful?
          messages.empty?
        end
      end
    end
  end
end
