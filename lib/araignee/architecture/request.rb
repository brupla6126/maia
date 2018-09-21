module Architecture
  module Story
    # A Request is sent to a User Story Interactor.
    # It contains the parameters for which a User Story Interactor
    # will act upon.
    # Derived class need to implement #permitted and #defaults
    class Request
      def initialize(params)
        @params = params
      end

      def params
        @real_params ||= defaults.merge(@params.select { |k| permitted.include?(k) })
      end

      def pagination_params
        {}
      end

      protected

      # array of permitted parameter names as symbols
      def permitted
        []
      end

      # hash of handled parameters with their default values
      def defaults
        {}
      end
    end
  end
end
