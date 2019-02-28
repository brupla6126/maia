require 'ostruct'

module Araignee
  module Stories
    # Validator helper part of Clean Architecture.
    # It validates an object and returns a response.
    class Validator
      def validate(object, context)
        response = new_response

        validate_object(object, context, response)

        response
      end

      protected

      def new_response
        OpenStruct.new
      end

      private

      # to be implemented in derived classes
      # object to be validated
      # context Symbol
      # response to store validation information
      def validate_object(_object, _context, _response); end
    end
  end
end
