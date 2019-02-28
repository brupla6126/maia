require 'ostruct'

module Araignee
  module Stories
    # It is returned by a User Story Interactor.
    # It contains response properties.
    class Response < OpenStruct
      def initialize(params: {}, defaults: {})
        super(defaults.merge(params))
      end
    end
  end
end
