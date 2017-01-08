require 'araignee/architecture/interactor'
require 'araignee/architecture/presenter'

module Araignee
  module Architecture
    # Orchestrator service part of Clean Architecture.
    # Interactor receives requests from controllers, gets data from entities, sends responses to presenters and returns the view model.
    class Orchestrator
      def initialize(interactors = [], presenters = [])
        @interactors = interactors
        @presenters = presenters
      end

      # Derived class can use this method as is or redefine it
      # to get specific behavior.
      def process(request_model, context = {})
        raise ArgumentError, 'request_model not set' unless request_model

        response_model = {}
        @interactors.each { |interactor| interactor.process(request_model, response_model, context) }

        view_model = {}
        @presenters.each { |presenter| presenter.process(response_model, view_model, context) }

        view_model
      end
    end
  end
end
