require 'artemisia/system'

module Artemisia
  module Systems
    class EntitySystem < System
      # attributes OpenStruct
      def initialize(attributes)
        attributes.type = :entity_system
        super(attributes)
      end

      def process; end
    end
  end
end
