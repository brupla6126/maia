require 'araignee/architecture/interactor'

RSpec.describe Architecture::Interactor do
  describe '#process' do
    let(:request_model) { { operation: 'books.count' } }
    let(:data_model) { {} }
    let(:context) { {} }

    context 'when class is not derived' do
      let(:interactor) { Architecture::Interactor.new }

      it 'should raise NotImplementedError' do
        expect { interactor.process(request_model, data_model, context) }.to raise_error(NotImplementedError)
      end
    end

    context 'when class is derived' do
      class InteractorImpl < Architecture::Interactor
        def interact(request_model, data_model, context)
        end
      end

      before do
        expect(interactor).to receive(:interact).with(request_model, data_model, context)
      end

      let(:interactor) { InteractorImpl.new }

      it 'data model is updated' do
        interactor.process(request_model, data_model, context)
      end
    end
  end
end
