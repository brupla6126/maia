module Araignee
  module Stories
    class Presenter
      def present(_request, data_model, response)
        response.merge!(data_model.dup) if data_model
      end
    end
  end
end
