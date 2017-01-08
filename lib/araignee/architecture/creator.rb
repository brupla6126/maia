require 'singleton'

module Araignee
  module Architecture
    # Creator service part of Clean Architecture.
    # Base class to create an entity and report a result object.
    class Creator
      include Singleton

      attr_reader :attributes

      def execute(attributes)
        @attributes = attributes

        create
      end

      protected

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
