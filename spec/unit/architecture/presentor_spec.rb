require 'araignee/architecture/presenter'

include Araignee::Architecture

RSpec.describe Presenter do
  describe '#process' do
    let(:presenter) { Presenter.new }

    context 'when not derived' do
      let(:response_model) { { books_count: 3 } }
      let(:view_model) { {} }

      it 'should raise NotImplementedError' do
        expect { presenter.process(response_model, view_model) }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      class PresenterImpl < Presenter
        def present
          @view_model[:books_count] = @response_model[:books_count].to_s
        end
      end

      let(:presenter_impl) { PresenterImpl.new }
      let(:response_model) { { books_count: 3 } }
      let(:view_model) { {} }

      it 'view model returned should be Hash' do
        presenter_impl.process(response_model, view_model)
        expect(view_model[:books_count]).to eq('3')
      end
    end
  end
end
