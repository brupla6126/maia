require 'araignee/ai/core/selector'

RSpec.describe Araignee::Ai::Core::Selector do
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
    let(:world) { {} }
    let(:entity) { {} }

    subject { selector.process(entity, world) }

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
end
