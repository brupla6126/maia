require 'araignee/architecture/interactor'

include Araignee::Architecture

RSpec.describe Interactor do
  describe '#process' do
    let(:request_model) { { operation: 'books.count' } }
    let(:data_model) { {} }
    let(:context) { {} }

    context 'when class is not derived' do
      let(:interactor) { Interactor.new }

      it 'should raise NotImplementedError' do
        expect { interactor.process(request_model, data_model, context) }.to raise_error(NotImplementedError)
      end
    end

    context 'when class is derived' do
      class InteractorImpl < Interactor
        def interact(request_model, data_model, context)
          data_model[:books_count] = 3
        end
      end

      let(:interactor) { InteractorImpl.new }

      it 'data model is updated' do
        interactor.process(request_model, data_model, context)

        expect(data_model[:books_count]).to eq(3)
      end
    end
  end
end
