require 'araignee/architecture/result'

module Architecture
  module Story
    # Validator helper part of Clean Architecture.
    # It validates an object and returns a result.
    class Validator
      def execute(object, context)
        result = new_result

        validate(object, context, result)

        result
      end

      protected

      def new_result
        Result.new
      end

      private

      # to be implemented in derived classes
      # object to be validated
      # context Symbol
      # result to store validation information
      def validate(_object, _context, _result); end
    end
  end
end
