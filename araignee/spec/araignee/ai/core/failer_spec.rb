require 'araignee/ai/core/failer'

RSpec.describe Araignee::Ai::Core::Failer do
  let(:child) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:failer) { described_class.new(child: child) }

  before do
    initialize_state(failer)
    initialize_state(child)
  end

  subject { failer }

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

      it 'failer has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when child response :failed' do
      let(:child) { Araignee::Ai::Core::NodeFailed.new }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
        subject
      end

      it 'failer has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
