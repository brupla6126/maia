require 'virtus'

module Araignee
  module Architecture
    # base class for entities
    class Entity
      include Virtus.model

      def initialize(attributes = {})
        super
      end
    end
  end
end
