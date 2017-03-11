require 'araignee/architecture/interactor'

include Araignee::Architecture

RSpec.describe Interactor do
  describe '#execute' do
    let(:interactor) { Interactor.new }
    let(:interactor_impl) { InteractorImpl.new }
    let(:request_model) { { operation: 'books.count' } }
    let(:response_model) { {} }

    context 'when class is not derived' do
      it 'should raise NotImplementedError' do
        expect { interactor.process(request_model, response_model) }.to raise_error(NotImplementedError)
      end
    end

    context 'when class is derived' do
      class InteractorImpl < Interactor
        def interact
          @response_model[:books_count] = 3
        end
      end

      it 'presenter.process should be called once' do
        interactor_impl.process(request_model, response_model)
      end

      it 'response model returned should be Hash' do
        interactor_impl.process(request_model, response_model)
        expect(response_model[:books_count]).to eq(3)
      end
    end
  end
end
