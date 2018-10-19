require 'araignee/ai/core/sequence'

RSpec.describe Araignee::Ai::Core::Sequence do
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

    let(:children) { [Araignee::Ai::Core::NodeSucceeded.new] }

    context 'when children = [:succeeded, :succeeded]' do
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when children = [:succeeded, :busy, :succeeded]' do
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeBusy.new, Araignee::Ai::Core::NodeSucceeded.new] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when children = [:failed, :succeeded]' do
      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
