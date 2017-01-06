module Araignee
  module Architecture
    # Creator creates an entity
    class Creator
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

      # Result class for Creator
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
