require 'araignee/architecture/orchestrator'

include Araignee, Araignee::Architecture

RSpec.describe Orchestrator do
  describe '#initialize' do
    context 'when interactors empty' do
      it 'should raise ArgumentError' do
        # expect { Orchestrator.new([], [1]) }.to raise_error(ArgumentError, '')
      end
    end

    context 'when presenters empty' do
      it 'should raise ArgumentError' do
        # expect { Orchestrator.new([1], []) }.to raise_error(ArgumentError, '')
      end
    end
  end

  describe '#process' do
    let(:interactor) { double('interactor') }
    let(:presenter) { double('presenter') }
    let(:request_model) { { operation: 'books.count' } }
    let(:response_model) { { books_count: 3 } }

    context 'when class is derived' do
      let(:orchestrator) { Orchestrator.new([interactor], [presenter]) }

      it 'interactor.process should be called once' do
        expect(interactor).to receive(:process).with(request_model, {}, {}).once
        expect(presenter).to receive(:process).with({}, {}, {}).once
        orchestrator.process(request_model)
      end

      it 'presenter.process should be called once' do
        expect(interactor).to receive(:process).with(request_model, {}, {}).once
        expect(presenter).to receive(:process).with({}, {}, {}).once
        orchestrator.process(request_model)
      end

      it 'response model returned should be Hash' do
        expect(interactor).to receive(:process).with(request_model, {}, {}).once.and_return(books_count: 3)
        expect(presenter).to receive(:process).with({}, {}, {}).once.and_return(books_count: '3')
        view_model = orchestrator.process(request_model)
        expect(view_model).to be_a(Hash)
        # expect(view_model[:books_count]).to eq('3')
      end
    end
  end
end
