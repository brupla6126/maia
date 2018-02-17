module Architecture
  module Story
    # It is returned by a User Story Interactor.
    # It Contains optional result and view model.
    class Response
      attr_reader :result
      attr_reader :view_model

      def initialize(result:, view_model:)
        @result = result
        @view_model = view_model
      end
    end
  end
end
