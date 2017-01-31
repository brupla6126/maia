require 'singleton'
require 'araignee/architecture/repository'
require 'araignee/architecture/services/service'

module Araignee
  module Architecture
    # Remover service part of Clean Architecture.
    # Base class to remove an entity and return a result object.
    class Remover
      include Singleton
      include Service

      attr_reader :filters

      def execute(filters, context = nil)
        @filters = filters
        @context = context || {}

        raise NotImplementedError, 'must derive this class' if self.class == Araignee::Architecture::Remover
        raise ArgumentError, 'filters empty' if filters.empty?

        remove
      end

      protected

      def remove
        remove_entity

        result
      end

      def remove_entity
        @response = repository.delete(@filters)
      end

      private

      def result
        Result.new(@filters, @response)
      end

      # Result class for Remover
      class Result
        attr_reader :filters, :response, :messages

        def initialize(filters, response, messages = [])
          raise ArgumentError, 'filters empty' if filters.empty?

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
