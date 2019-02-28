require 'araignee/stories/presenter'

module Araignee
  module Stories
    class Interactor
      attr_reader :config, :context

      def initialize(context:, config: nil)
        @config = config
        @context = context
      end

      def process(request)
        response = respond

        validate(request, response)

        model = data_model(request, response)

        present(request, model, response)

        response
      end

      private

      def respond
        { status: :ok }
      end

      def validate(request, response)
        action_validators = validators[request.action] || []

        action_validators.each do |validator|
          validator.validate(request, response)
        end
      end

      def present(request, data_model, response)
        action_presenters = presenters[request.action] || []
        action_presenters << Presenter.new if presenters.empty?

        action_presenters.each do |presenter|
          presenter.present(request, data_model, response)
        end
      end

      # data model need to be implemented in derived classes
      def data_model(_request, _response)
        {}
      end

      # validators need to be declared in derived classes if any
      def validators
        {}
      end

      # presenters need to be injected in context if any
      def presenters
        @context.presenters || {}
      end
    end
  end
end
