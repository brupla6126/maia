require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/service'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Finder service part of Clean Architecture.
    # Base class to find entity(ies) and return a result object.
    class Finder
      include Singleton
      include Service

      def one(filters)
        raise ArgumentError, 'filters empty' if filters.empty?
        raise NotImplementedError, 'must derive this class' if self.class == Araignee::Architecture::Finder

        @filters = filters

        find_one

        result
      end

      def many(filters, sort = nil, limit = nil)
        raise ArgumentError, 'filters empty' if filters.empty?
        raise NotImplementedError, 'must derive this class' if self.class == Araignee::Architecture::Finder

        @filters = filters
        @sort = sort
        @limit = limit

        find_many

        result
      end

      protected

      def find_one
        @entity = nil

        data = repository.one(@filters)

        @entity = entity_class.new(data) if data
      end

      def find_many
        data = repository.many(@filters, @sort, @limit)

        @entities = []

        data.each do |d|
          @entities << entity_class.new(d) if data
        end
      end

      def validation
        @validation ||= validator.execute(@entity, @context)
      end

      def result
        Result.new(@filters, @entity, @entities, validation.messages)
      end

      # Result class for Finder
      class Result
        attr_reader :filters, :entity, :entities, :messages

        def initialize(filters, entity, entities, messages = [])
          raise ArgumentError, 'filters must be set' if filters.empty?

          @filters = filters
          @entity = entity
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
