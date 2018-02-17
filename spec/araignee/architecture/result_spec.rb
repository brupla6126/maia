require 'araignee/architecture/result'

RSpec.describe Architecture::Story::Result do
  subject { result }

  let(:result) { described_class.new }

  describe '#initialize' do
    it 'params are set to defaults' do
      expect(subject.infos).to eq([])
      expect(subject.warnings).to eq([])
      expect(subject.errors).to eq([])
    end
  end

  describe '#successful?' do
    subject { super().successful? }

    it { expect(subject).to eq(true) }

    context 'with errors' do
      before { result.errors << 'abc.xyz' }

      it { expect(subject).to eq(false) }
    end
  end
end
