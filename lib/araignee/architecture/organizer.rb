module Araignee
  module Architecture
    # Organizer
    # It receives a response model, process its data into a view model.
    class Organizer
      def process(response_model, view_model, context = {})
        raise ArgumentError, 'response_model not set' unless response_model
        raise ArgumentError, 'view_model not set' unless view_model

        @response_model = response_model
        @view_model = view_model
        @context = context || {}

        organize
      end

      protected

      # Derived class can process the response model and
      # prepare(format, translate, localize, ...) data into a view model
      def organize
        raise NotImplementedError
      end
    end
  end
end
