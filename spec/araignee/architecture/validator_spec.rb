require 'araignee/architecture/validator'

RSpec.describe Architecture::Story::Validator do
  subject { validator }

  let(:validator) { described_class.new }

  describe '#execute' do
    subject { super().execute(object, context) }

    let(:object) { { name: 'joe' } }
    let(:context) { {} }

    let(:result) { Architecture::Story::Result.new }

    before do
      allow(validator).to receive(:new_result).and_return(result)
      allow(validator).to receive(:validate).with(object, context, result)
    end

    it 'it validates' do
      expect(validator).to receive(:validate).with(object, context, result)
      subject
    end

    it 'returns the result' do
      expect(subject).to eq(result)
    end
  end

  describe 'new_result' do
    subject { super().send(:new_result) }

    it 'return a Architecture::Result' do
      expect(subject).to be_a(Architecture::Story::Result)
    end
  end
end
