module Araignee
  module Architecture
    # Interactor component part of Clean Architecture.
    # It receives requests from controllers, gets/sets data from/to entities and modifies the response model.
    class Interactor
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

      # Derived class can process request model and store
      # the data from entities into the response model
      def interact
        raise NotImplementedError
      end
    end
  end
end
