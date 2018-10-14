require 'ostruct'

module Story
  # A Request is sent to a User Story Interactor.
  # It contains the parameters for which a User Story Interactor
  # will act upon.
  # Derived class need to implement #allowed and #defaults
  class Request < OpenStruct
    def initialize(params)
      super(defaults.merge(params))
    end

    def valid?
      raise ArgumentError, "unallowed params: #{unallowed(to_h.keys).join(', ')}" unless unallowed(to_h.keys).empty?

      true
    end

    protected

    # array of permitted parameter names as symbols
    def allowed
      []
    end

    # hash of handled parameters with their default values
    def defaults
      {}
    end

    def unallowed(params)
      (params - allowed)
    end
  end
end
