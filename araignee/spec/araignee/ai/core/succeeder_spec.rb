require 'araignee/ai/core/succeeder'

RSpec.describe Araignee::Ai::Core::Succeeder do
  let(:node_failed) { Araignee::Ai::Core::NodeFailed.new }
  let(:node_succeeded) { Araignee::Ai::Core::NodeSucceeded.new }

  let(:child) { node_succeeded }

  let(:succeeder) { described_class.new(child: child) }

  before do
    initialize_state(succeeder)
    initialize_state(child)
  end

  subject { succeeder }

  describe '#initialize' do
    it 'has its child set' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when child response :succeeded' do
      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
        subject
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child response :failed' do
      let(:child) { node_failed }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
        subject
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
