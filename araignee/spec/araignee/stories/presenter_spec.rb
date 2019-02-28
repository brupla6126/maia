require 'araignee/stories/presenter'

RSpec.describe Araignee::Stories::Presenter do
  let(:presenter) { described_class.new }

  subject { presenter }

  describe '#present' do
    subject { super().present(request, data_model, response) }

    let(:request) { { action: :create } }
    let(:response) { { view: { b: 2 } } }
    let(:data_model) { { data: { a: 1 } } }

    it 'returns the data model merged into the response' do
      expect(subject).to eq(response.merge(data_model))
    end
  end
end
