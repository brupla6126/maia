require 'forwardable'

module Artemisia
  class Manager
    extend Forwardable

    def_delegators :@attributes, :type

    # attributes OpenStruct
    #   - :type Symbol
    def initialize(attributes)
      @attributes = attributes

      raise ArgumentError, 'missing type' unless @attributes[:type]
    end
  end
end
