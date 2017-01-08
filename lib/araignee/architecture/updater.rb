require 'singleton'

module Araignee
  module Architecture
    # Updater service part of Clean Architecture.
    #  Base class to update an entity and report a result object.
    class Updater
      include Singleton

      attr_reader :attributes

      def execute(id, attributes)
        @id = id
        @attributes = attributes

        update
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
