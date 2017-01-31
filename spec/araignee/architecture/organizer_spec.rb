require 'araignee/architecture/organizer'

include Araignee::Architecture

RSpec.describe Organizer do
  describe '#process' do
    let(:organizer) { Organizer.new }

    context 'when not derived' do
      let(:response_model) { { books_count: 3 } }
      let(:view_model) { {} }

      it 'should raise NotImplementedError' do
        expect { organizer.process(response_model, view_model) }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      class OrganizerImpl < Organizer
        def organize
          @view_model[:books_count] = @response_model[:books_count].to_s
        end
      end

      let(:organizer_impl) { OrganizerImpl.new }
      let(:response_model) { { books_count: 3 } }
      let(:view_model) { {} }

      it 'model data should be organized into view model' do
        organizer_impl.process(response_model, view_model)
        expect(view_model[:books_count]).to eq('3')
      end
    end
  end
end
