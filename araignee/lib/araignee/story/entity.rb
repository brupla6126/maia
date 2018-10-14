require 'ostruct'

module Story
  class Entity < OpenStruct
    def initialize(params)
      super(defaults.merge(params))
    end

    private

    def defaults
      {}
    end
  end
end
