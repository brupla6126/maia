require 'araignee/ai/core/node'
require 'araignee/ai/core/xor'
require 'araignee/ai/core/filters/filter_running'

RSpec.describe Ai::Core::Xor do
  let(:world) { {} }
  let(:entity) { {} }

  let(:filter) { Ai::Core::Filters::FilterRunning.new }

  let(:children) { [] }
  let(:xor) { described_class.new(children: children, filters: [filter]) }

  subject { xor }

  describe '#initialize' do
    context 'when children is not set' do
      let(:xor) { described_class.new }

      it 'children set to default value' do
        expect(subject.children).to eq([])
      end
    end
  end

  describe 'process' do
    subject { super().process(entity, world) }

    before { xor.start! }

    context 'when responses = [:succeeded]' do
      let(:children) { [Ai::Core::NodeSucceeded.new] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when responses = [:succeeded, :succeeded]' do
      let(:children) { [Ai::Core::NodeSucceeded.new, Ai::Core::NodeSucceeded.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed]' do
      let(:children) { [Ai::Core::NodeFailed.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed, :succeeded, :busy]' do
      let(:children) { [Ai::Core::NodeFailed.new, Ai::Core::NodeSucceeded.new, Ai::Core::NodeBusy.new] }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end

  describe 'prepare_nodes' do
    subject { super().send(:prepare_nodes, nodes) }

    let(:nodes) { [] }
    let(:sort_reversed) { false }

    context 'calling #filter' do
      before { allow(xor).to receive(:filter).with(children) { children } }

      let(:sort_reversed) { false }

      it 'calls #filter' do
        expect(xor).to receive(:filter).with(children)
        subject
      end
    end

    it '' do
      expect(subject).to eq(nodes)
    end
  end
end
