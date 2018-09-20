module Architecture
  module Story
    # It is returned by a User Story Interactor or Request.
    class Result
      attr_reader :status, :infos, :warnings, :errors

      def initialize
        @status = {}
        @infos = []
        @warnings = []
        @errors = []
      end

      def successful?
        @errors.empty?
      end

      def to_h
        { status: status, infos: infos, warnings: warnings, errors: errors }
      end
    end
  end
end
