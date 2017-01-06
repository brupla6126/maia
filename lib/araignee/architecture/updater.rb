module Araignee
  module Architecture
    # Updater updates an entity
    class Updater
      attr_reader :attributes

      def self.execute(id, attributes)
        new(id, attributes).update
      end

      def initialize(id, attributes)
        @id = id
        @attributes = attributes
      end

      def update
        raise NotImplementedError
      end

      # Result class for Updater
      class Result
        attr_reader :entity, :messages

        def initialize(id, entity, messages = [])
          @id = id
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
