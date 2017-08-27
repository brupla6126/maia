require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/xor'

include AI::Actions

RSpec.describe AI::Behaviors::Xor do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  let(:nodes) { [ActionFailed.new] }
  let(:term_xor) { AI::Behaviors::Xor.new(nodes: nodes) }

  describe 'process' do
    before { term_xor.start! }
    before { term_xor.process(entity, world) }
    subject { term_xor }

    context 'when terms are [:failed, :failed]' do
      let(:nodes) { [ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when terms are [:failed, :succeeded]' do
      let(:nodes) { [ActionFailed.new, ActionSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when terms are [:succeeded, :failed]' do
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when terms are [:succeeded, :succeeded]' do
      let(:nodes) { [ActionSucceeded.new, ActionSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when terms are [:succeeded, :running, :succeeded]' do
      let(:nodes) { [ActionSucceeded.new, ActionRunning.new, ActionSucceeded.new] }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(term_xor)
    end
  end
end
