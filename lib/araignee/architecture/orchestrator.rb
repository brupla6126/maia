require 'araignee/architecture/interactor'
require 'araignee/architecture/presenter'

module Araignee
  module Architecture
    # Orchestrator component part of Clean Architecture.
    class Orchestrator
      def initialize(interactors = [], presenters = [])
        @interactors = interactors
        @presenters = presenters
      end

      # Derived class can use this method as is or redefine it
      # to get specific behavior using the waterfall gem.
      def process(request_model, data_model, response_model, context = nil)
        @interactors.each { |interactor| interactor.process(request_model, data_model, context) }

        @presenters.each { |presenter| presenter.process(data_model, response_model, context) }
      end
    end
  end
end
