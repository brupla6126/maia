module Araignee
  module Architecture
    # Interactor component part of Clean Architecture.
    # It receives requests from controllers, gets/sets data from/to entities and modifies the data model.
    class Interactor
      def process(request_model, data_model, context = nil)
        interact(request_model, data_model, context)
      end

      protected

      # Derived class can process request model and store
      # the data from entities into the response model
      def interact(_request_model, _data_model, _context)
        raise NotImplementedError
      end
    end
  end
end
