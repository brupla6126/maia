require 'ostruct'

module Story
  # It is returned by a User Story Interactor.
  # It contains response properties.
  class Response < OpenStruct
    def initialize(params = {})
      super(defaults.merge(params))
    end

    # hash of handled parameters with their default values
    def defaults
      {}
    end
  end
end
