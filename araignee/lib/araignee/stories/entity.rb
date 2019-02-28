require 'ostruct'

module Araignee
  module Stories
    class Entity < OpenStruct
      def initialize(attributes:, defaults: {})
        super(defaults.merge(attributes))
      end
    end
  end
end
