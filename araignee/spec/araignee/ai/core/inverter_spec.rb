require 'araignee/ai/core/inverter'

RSpec.describe Araignee::Ai::Core::Inverter do
  let(:child) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:inverter) { described_class.new(child: child) }

  before do
    child.state = initial_state
    inverter.state = initial_state
  end

  subject { inverter }

  describe '#initialize' do
    it 'sets child' do
      expect(inverter.child).to eq(child)
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when inverter processes a node that succeeded' do
      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when inverter processes a node that failed' do
      let(:child) { Araignee::Ai::Core::NodeFailed.new }

      it 'has not failed' do
        expect(subject.failed?).to eq(false)
      end
    end

    context 'when inverter processes a node that is busy' do
      let(:child) { Araignee::Ai::Core::NodeBusy.new }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end
end
