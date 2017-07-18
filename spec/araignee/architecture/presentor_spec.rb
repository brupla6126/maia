require 'araignee/architecture/presenter'

include Araignee::Architecture

RSpec.describe Presenter do
  describe '#process' do
    let(:data_model) { { books_count: 3 } }
    let(:response_model) { {} }
    let(:context) { {} }

    context 'when not derived' do
      let(:presenter) { Presenter.new }

      it 'should raise NotImplementedError' do
        expect { presenter.process(data_model, response_model, context) }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      class PresenterImpl < Presenter
        def present(data_model, response_model, context)
          response_model[:books_count] = data_model[:books_count].to_s
        end
      end

      let(:presenter) { PresenterImpl.new }

      it 'model data should be presented into response_model model' do
        presenter.process(data_model, response_model, context)

        expect(response_model[:books_count]).to eq('3')
      end
    end
  end
end
