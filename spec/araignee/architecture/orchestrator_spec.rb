require 'araignee/architecture/orchestrator'

RSpec.describe Architecture::Orchestrator do
  describe '#process' do
    let(:interactor) { double('interactor') }
    let(:presenter) { double('presenter') }
    let(:request_model) { { operation: 'books.count' } }

    context 'when class is derived' do
      let(:orchestrator) { Architecture::Orchestrator.new([interactor], [presenter]) }

      let(:data_model) { {} }
      let(:response_model) { {} }
      let(:context) { {} }

      it 'Interactor#process should be called once' do
        expect(interactor).to receive(:process).with(request_model, data_model, context).once
        expect(presenter).to receive(:process).with(data_model, response_model, context).once

        orchestrator.process(request_model, data_model, response_model, context)
      end

      it 'Presenter#process should be called once' do
        expect(interactor).to receive(:process).with(request_model, data_model, context).once
        expect(presenter).to receive(:process).with(data_model, response_model, context).once

        orchestrator.process(request_model, data_model, response_model, context)
      end

      it 'Interator#process and Presenter#process should be called' do
        expect(interactor).to receive(:process).with(request_model, data_model, context).once.and_return(books_count: 3)
        expect(presenter).to receive(:process).with(data_model, response_model, context).once.and_return(books_count: '3')

        orchestrator.process(request_model, data_model, response_model, context)
      end
    end
  end
end
