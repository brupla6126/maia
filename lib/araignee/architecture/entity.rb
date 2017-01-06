require 'virtus'

module Araignee
  module Architecture
    # base class for entities
    class Entity
      include Virtus.model

      def initialize(attributes = {})
        super

        validate_attributes
      end

      def validate_attributes; end
    end
  end
end
