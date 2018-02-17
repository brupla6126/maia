module Architecture
  module Story
    # It is returned by a User Story Interactor or Request.
    class Result
      attr_reader :errors, :warnings, :infos

      def initialize
        @errors = []
        @warnings = []
        @infos = []
      end

      def successful?
        errors.empty?
      end
    end
  end
end
