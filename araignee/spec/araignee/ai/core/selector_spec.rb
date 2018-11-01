require 'araignee/ai/core/selector'

RSpec.describe Araignee::Ai::Core::Selector do
  let(:child_succeeded) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:child_failed) { Araignee::Ai::Core::NodeFailed.new }
  let(:child_busy) { Araignee::Ai::Core::NodeBusy.new }
  let(:children) { [1, 2, 3] }
  let(:selector) { described_class.new(children: children, filters: []) }

  before do
    child_succeeded.state = initial_state
    child_failed.state = initial_state
    child_busy.state = initial_state
    selector.state = initial_state
  end

  subject { selector }

  describe '#initialize' do
    it 'sets children' do
      expect(subject.children).to eq(children)
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when :succeeded' do
      let(:children) { [child_succeeded] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when :failed, :failed, :succeeded' do
      let(:children) { [child_failed, child_failed, child_succeeded] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when :failed, :busy' do
      let(:children) { [child_failed, child_busy] }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when :failed, :failed' do
      let(:children) { [child_failed, child_failed] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
