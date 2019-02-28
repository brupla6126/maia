require 'ostruct'

module Araignee
  module Stories
    # A Request is sent to a User Story Interactor.
    # It contains the parameters for which a User Story Interactor
    # will act upon.
    class Request < OpenStruct
      # params Hash request params
      def initialize(params:, allowed: [], defaults: {})
        super(defaults.merge(params))

        @allowed = allowed

        raise ArgumentError, "unallowed params: #{unallowed(to_h.keys.sort).join(', ')}" unless unallowed(to_h.keys).empty?
      end

      protected

      def unallowed(params)
        (params - @allowed)
      end
    end
  end
end
