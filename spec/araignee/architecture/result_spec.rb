require 'araignee/architecture/result'

RSpec.describe Architecture::Story::Result do
  subject { result }

  let(:result) { described_class.new }

  describe '#initialize' do
    it 'is initialized' do
      expect(result.infos).to eq([])
      expect(result.warnings).to eq([])
      expect(result.errors).to eq([])
    end
  end

  describe '#successful?' do
    subject { super().successful? }

    context 'when errors not set' do
      it 'returns true' do
        expect(subject).to eq(true)
      end

      it 'does not have errors' do
        expect(result.errors).to eq([])
      end
    end

    context 'when errors are set' do
      before { result.errors << 'a' }

      it 'returns false' do
        expect(subject).to eq(false)
      end

      it 'has 2 errors' do
        expect(result.errors).to eq(%w[a])
      end
    end
  end

  describe 'to_h' do
    subject { super().to_h }

    let(:infos) { %w[a b] }
    let(:warnings) { %w[c d] }
    let(:errors) { %w[e f] }

    before do
      allow(result).to receive(:infos) { infos }
      allow(result).to receive(:warnings) { warnings }
      allow(result).to receive(:errors) { errors }
    end

    it 'returns a hash' do
      expect(subject[:infos]).to eq(infos)
      expect(subject[:warnings]).to eq(warnings)
      expect(subject[:errors]).to eq(errors)
    end
  end
end
