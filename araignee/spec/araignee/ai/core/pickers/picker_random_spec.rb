require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker_random'

RSpec.describe Araignee::Ai::Core::Pickers::PickerRandom do
  let(:picker) { described_class.new }

  let(:nodes) { (1..3).map { Araignee::Ai::Core::Node.new } }

  describe '#pick_one' do
    subject { picker.pick_one(nodes) }

    it 'does not return nil' do
      expect(subject).not_to eq(nil)
    end

    it 'does not return nodes' do
      expect(subject).not_to eq(nodes)
    end

    context 'with nodes empty' do
      let(:nodes) { [] }

      it 'return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'calling nodes#sample' do
      before { allow(nodes).to receive(:sample) }

      it 'calls nodes#sample' do
        expect(nodes).to receive(:sample)
        subject
      end
    end
  end

  describe '#pick_many' do
    subject { picker.pick_many(nodes) }

    context 'with nodes empty' do
      let(:nodes) { [] }

      it 'return empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with nodes' do
      it 'returns nodes random' do
        expect(subject).not_to eq(nodes)
      end
    end

    context 'calling nodes#shuffle' do
      before { allow(nodes).to receive(:shuffle) { nodes } }

      it 'calls nodes#sample' do
        expect(nodes).to receive(:shuffle)
        subject
      end
    end
  end
end
