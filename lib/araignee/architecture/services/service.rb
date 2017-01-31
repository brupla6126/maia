require 'araignee/architecture/repository'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Creator service part of Clean Architecture.
    # Base class to create an service.
    module Service
      protected

      def sibling_class(type)
        Object.const_get(self.class.to_s.split('::')[0...-1].push(type.to_s.capitalize).join('::'))
      end

      def entity_class
        sibling_class(:entity)
      end

      def repository
        Repository.for(sibling_class(:entity))
      end

      def validator
        sibling_class(:validator).instance
      end
    end
  end
end
