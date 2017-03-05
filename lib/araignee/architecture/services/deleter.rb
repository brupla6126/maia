require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/service'

module Araignee
  module Architecture
    module Services
      # Forward declaration to solve circular dependencies
      module Service
      end

      # Deleter service part of Clean Architecture.
      # Base class to delete an entity and return a result object.
      class Deleter
        include Singleton
        include Service

        def delete(klass: nil, filters: {})
          raise ArgumentError, 'klass invalid' unless klass
          raise ArgumentError, 'filters empty' if filters.empty?

          response = delete_entity(klass, filters)

          Result.new(klass, filters, response)
        end

        protected

        def delete_entity(klass, filters)
          storage(klass).delete(filters)
        end

        # Result class for Deleter
        class Result
          attr_reader :klass, :filters, :response, :messages

          def initialize(klass, filters, response, messages = [])
            raise ArgumentError, 'klass must be set' unless klass
            raise ArgumentError, 'filters empty' if filters.empty?

            @klass = klass
            @filters = filters
            @response = response
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
