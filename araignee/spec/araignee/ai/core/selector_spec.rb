require 'araignee/ai/core/selector'

RSpec.describe Araignee::Ai::Core::Selector do
  let(:world) { {} }
  let(:entity) { {} }

  let(:children) { [] }
  let(:selector) { described_class.new(children: children, filters: []) }

  subject { selector }

  describe '#initialize' do
    context 'when children is not set' do
      let(:selector) { described_class.new }

      it 'children set to default value' do
        expect(subject.children).to eq([])
      end
    end
  end

  describe '#process' do
    subject { selector.process(entity, world) }

    context 'calling #prepare_nodes' do
      before { allow(selector).to receive(:prepare_nodes).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #prepare_nodes' do
        expect(selector).to receive(:prepare_nodes).with(children, sort_reversed)
        subject
      end
    end

    context 'when :succeeded' do
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when :failed, :failed, :succeeded' do
      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeSucceeded.new] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when :failed, :busy' do
      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeBusy.new] }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when :failed, :failed' do
      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end

  describe 'prepare_nodes' do
    subject { super().send(:prepare_nodes, nodes, sort_reversed) }

    let(:nodes) { [] }
    let(:sort_reversed) { false }

    context 'calling #filter and #sort' do
      before { allow(selector).to receive(:filter).with(children) { children } }
      before { allow(selector).to receive(:sort).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #filter and #sort' do
        expect(selector).to receive(:filter).with(children)
        expect(selector).to receive(:sort).with(children, sort_reversed)
        subject
      end
    end

    it '' do
      expect(subject).to eq(nodes)
    end
  end
end
