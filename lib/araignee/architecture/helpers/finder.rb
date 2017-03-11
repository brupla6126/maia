require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/helpers/helper'

module Araignee
  module Architecture
    module Helpers
      # Forward declaration to solve circular dependencies
      module Helper
      end

      # Finder helper part of Clean Architecture.
      # Base class to find entity(ies) and return a result object.
      class Finder
        include Singleton
        include Helper

        def one(klass: nil, filters: {})
          raise ArgumentError, 'klass invalid' unless klass
          raise ArgumentError, 'filters empty' if filters.empty?

          find_one(klass, filters)
        end

        def many(klass: nil, filters: {}, sort: nil, limit: nil)
          raise ArgumentError, 'klass invalid' unless klass

          find_many(klass, filters, sort, limit)
        end

        protected

        def find_one(klass, filters)
          data = storage(klass).one(filters)

          entity = data ? klass.new(data) : nil

          Result.new(klass, filters, entity)
        end

        def find_many(klass, filters, sort, limit)
          data = storage(klass).many(filters, sort, limit)

          entities = []

          if data
            data.each do |d|
              entities << klass.new(d) if data
            end
          end

          Result.new(klass, filters, nil, entities)
        end

        # Result class for Finder
        class Result
          attr_reader :filters, :entity, :entities, :messages

          def initialize(klass, filters = {}, entity = nil, entities = nil, messages = [])
            raise ArgumentError, 'klass must be set' unless klass

            @klass = klass
            @filters = filters
            @entity = entity if entity
            @entities = entities if entities
            @messages = messages
          end

          def successful?
            @messages.empty?
          end
        end
      end
    end
  end
end
