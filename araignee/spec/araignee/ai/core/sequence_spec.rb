require 'araignee/ai/core/sequence'

RSpec.describe Ai::Core::Sequence do
  let(:world) { {} }
  let(:entity) { {} }

  let(:children) { [] }
  let(:sequence) { described_class.new(children: children, filters: []) }

  subject { sequence }

  describe '#initialize' do
    context 'when children is not set' do
      let(:sequence) { described_class.new }

      it 'children set to default value' do
        expect(subject.children).to eq([])
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    let(:children) { [Ai::Core::NodeSucceeded.new] }

    context 'calling #prepare_nodes' do
      before { allow(sequence).to receive(:prepare_nodes).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #prepare_nodes' do
        expect(sequence).to receive(:prepare_nodes).with(children, sort_reversed)
        subject
      end
    end

    context 'when children = [:succeeded, :succeeded]' do
      let(:children) { [Ai::Core::NodeSucceeded.new, Ai::Core::NodeSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when children = [:succeeded, :busy, :succeeded]' do
      let(:children) { [Ai::Core::NodeSucceeded.new, Ai::Core::NodeBusy.new, Ai::Core::NodeSucceeded.new] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when children = [:failed, :succeeded]' do
      let(:children) { [Ai::Core::NodeFailed.new, Ai::Core::NodeSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end

  describe 'prepare_nodes' do
    subject { super().send(:prepare_nodes, nodes, sort_reversed) }

    let(:nodes) { [] }
    let(:sort_reversed) { false }

    context 'calling #filter and #sort' do
      before { allow(sequence).to receive(:filter).with(children) { children } }
      before { allow(sequence).to receive(:sort).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #filter and #sort' do
        expect(sequence).to receive(:filter).with(children)
        expect(sequence).to receive(:sort).with(children, sort_reversed)
        subject
      end
    end

    it '' do
      expect(subject).to eq(nodes)
    end
  end
end
