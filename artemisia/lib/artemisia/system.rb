require 'forwardable'
require 'artemisia/aspect'

module Artemisia
  class System
    extend Forwardable

    def_delegators :@attributes, :type, :aspect, :active

    # attributes OpenStruct
    #   - :type Symbol
    #   - :aspect Artemisia::Aspect
    #   - :active Boolean
    def initialize(attributes)
      @attributes = attributes

      raise ArgumentError, 'missing type' unless @attributes[:type]
      raise ArgumentError, 'missing aspect' unless @attributes[:aspect]
    end

    def activate
      @attributes[:active] = true
    end

    def deactivate
      @attributes[:active] = false
    end

    def dummy?
      @attributes[:aspect].empty?
    end
  end
end
