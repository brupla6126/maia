require 'araignee/architecture/presenter'

RSpec.describe Architecture::Presenter do
  describe '#process' do
    let(:data_model) { { books_count: 3 } }
    let(:response_model) { {} }
    let(:context) { {} }

    context 'when not derived' do
      let(:presenter) { Architecture::Presenter.new }

      it 'should raise NotImplementedError' do
        expect { presenter.process(data_model, response_model, context) }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      class PresenterImpl < Architecture::Presenter
        def present(data_model, response_model, context)
        end
      end

      before do
        expect(presenter).to receive(:present).with(data_model, response_model, context)
      end

      let(:presenter) { PresenterImpl.new }

      it 'model data should be presented into response_model' do
        presenter.process(data_model, response_model, context)
      end
    end
  end
end
