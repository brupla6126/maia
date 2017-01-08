require 'araignee/architecture/output_boundary'

module Araignee
  module Architecture
    # Presenter service part of Clean Architecture.
    # It receives a response model, process its data into a view model.
    class Presenter < OutputBoundary
      def process(response_model, view_model, context = {})
        raise ArgumentError, 'response_model not set' unless response_model
        raise ArgumentError, 'view_model not set' unless view_model

        @response_model = response_model
        @view_model = view_model
        @context = context || {}

        present
      end

      protected

      # Derived class can process the response model and
      # prepare(format, translate, localize, ...) data into a view model
      def present
        raise NotImplementedError
      end
    end
  end
end
