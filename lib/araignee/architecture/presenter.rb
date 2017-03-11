module Araignee
  module Architecture
    # Presenter component part of MVP.
    # It receives an entity and delivers prepared(format, translate, localize) data on request.
    class Presenter
      def initialize(entity)
        raise ArgumentError, 'entity must be set' unless entity

        @entity = entity
      end
    end
  end
end
