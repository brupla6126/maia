require 'ostruct'

module Artemisia
  class Component < OpenStruct
    def initialize(attributes)
      super(attributes)

      raise ArgumentError, 'missing type attribute' unless attributes[:type]
    end
  end
end
