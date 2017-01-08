require 'singleton'

module Araignee
  module Architecture
    # Finder service part of Clean Architecture.
    # Base class to find entity(ies) and report a result object.
    class Finder
      include Singleton

      attr_reader :filters

      def execute(filters, sort = nil, limit = nil)
        raise ArgumentError, 'filters empty' if filters.empty?

        @filters = filters
        @sort = sort
        @limit = limit

        find
      end

      protected

      def find
        raise NotImplementedError
      end

      # Result class for Finder
      class Result
        attr_reader :filters, :entities, :messages

        def initialize(filters, entities = [], messages = [])
          raise ArgumentError, 'filters must be set' if filters.empty?

          @filters = filters
          @entities = entities
          @messages = messages
        end

        def successful?
          @messages.empty?
        end
      end
    end
  end
end
