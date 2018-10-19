require 'araignee/ai/core/pickers/picker_round_robin'

RSpec.describe Araignee::Ai::Core::Pickers::PickerRoundRobin do
  let(:picker) { described_class.new }

  subject { picker }

  let(:nodes) { %i[a d b c] }

  describe '#initialize' do
    it 'assigns attributes' do
      expect(subject.current).to eq(0)
    end
  end

  describe '#pick' do
    it 'returns appropriate node' do
      expect(subject.pick(nodes)).to eq([nodes[0]])
      expect(subject.pick(nodes)).to eq([nodes[1]])
      expect(subject.pick(nodes)).to eq([nodes[2]])
      expect(subject.pick(nodes)).to eq([nodes[3]])
      expect(subject.pick(nodes)).to eq([nodes[0]])
    end
  end

  describe 'reset' do
    subject { super().reset }

    before { picker.pick(nodes) }

    it 'resets current to 0' do
      subject
      expect(picker.current).to eq(0)
    end
  end
end
