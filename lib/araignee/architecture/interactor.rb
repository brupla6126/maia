require 'araignee/architecture/input_boundary'

module Araignee
  module Architecture
    # Interactor receives requests from controllers, gets data from entities, sends responses to presenters and returns the view model.
    class Interactor < InputBoundary
      def process(request_model, response_model, context = {})
        raise ArgumentError, 'request_model not set' unless request_model
        raise ArgumentError, 'response_model not set' unless response_model
        raise ArgumentError, 'context not set' unless context

        @request_model = request_model
        @response_model = response_model
        @context = context

        interact
      end

      protected

      # process request model and store the data from entities into the response model
      def interact
        raise NotImplementedError
      end
    end
  end
end
