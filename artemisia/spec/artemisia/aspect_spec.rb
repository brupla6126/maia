require 'artemisia/aspect'

RSpec.describe Artemisia::Aspect do
  let(:aspect) { described_class.new(one: one, all: all, exclude: exclude) }
  let(:one) { nil }
  let(:all) { nil }
  let(:exclude) { nil }

  subject { aspect }

  describe '#initialize' do
    it 'initializes properly' do
      subject
      expect(aspect.one).to eq([])
      expect(aspect.all).to eq([])
      expect(aspect.exclude).to eq([])
    end
  end

  it 'how to select components' do
  end

  describe '#empty?' do
    subject { super().empty? }

    context 'one set is not empty, all set is not empty' do
      let(:one) { %i[a] }
      let(:all) { %i[b c] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'one set is empty, all set is not empty' do
      let(:one) { %i[] }
      let(:all) { %i[b c] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'one set is not empty, all set is empty' do
      let(:one) { %i[a] }
      let(:all) { %i[] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'one set is empty, all set is empty' do
      let(:one) { %i[] }
      let(:all) { %i[] }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end
end
