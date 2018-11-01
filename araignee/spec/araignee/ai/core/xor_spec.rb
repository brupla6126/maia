require 'araignee/ai/core/xor'

RSpec.describe Araignee::Ai::Core::Xor do
  let(:child_succeeded) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:child_failed) { Araignee::Ai::Core::NodeFailed.new }
  let(:child_busy) { Araignee::Ai::Core::NodeBusy.new }
  let(:children) { [1, 2, 3] }
  let(:xor) { described_class.new(children: children, filters: []) }

  before do
    child_succeeded.state = initial_state
    child_failed.state = initial_state
    child_busy.state = initial_state
    xor.state = initial_state
  end

  subject { xor }

  describe '#initialize' do
    it 'sets children' do
      expect(subject.children).to eq(children)
    end
  end

  describe 'process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when responses = [:succeeded]' do
      let(:children) { [child_succeeded] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when responses = [:succeeded, :succeeded]' do
      let(:children) { [child_succeeded, child_succeeded] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed]' do
      let(:children) { [child_failed] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed, :succeeded, :busy]' do
      let(:children) { [child_failed, child_succeeded, child_busy] }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end
end
