module Araignee
  module Architecture
    # Presenter component part of MVP.
    # It receives an entity and delivers prepared(format, translate, localize) data on request.
    class Presenter
      def process(data_model, response_model, context = nil)
        present(data_model, response_model, context)
      end

      private

      # Derived class can process the response model and
      # prepare(format, translate, localize, ...) data into a view model
      def present(data_model, response_model, context)
        raise NotImplementedError
      end
    end
  end
end
