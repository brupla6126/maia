require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/xor'

include AI::Actions

RSpec.describe AI::Behaviors::Xor do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  let(:nodes) { [ActionFailed.new] }
  let(:term_xor) { AI::Behaviors::Xor.new(nodes: nodes) }

  describe '#start' do
    context 'when nodes empty' do
      let(:nodes) { [] }

      it 'should raise ArgumentError must have at least one child node' do
        expect { term_xor.fire_state_event(:start) }.to raise_error(ArgumentError, 'must have at least one child node')
      end
    end
  end

  describe 'process' do
    before { term_xor.fire_state_event(:start) }
    subject { term_xor.process(entity, world) }

    context 'when terms are [false, false]' do
      let(:nodes) { [ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when terms are [false, true]' do
      let(:nodes) { [ActionFailed.new, ActionSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when terms are [true, false]' do
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when terms are [true, true]' do
      let(:nodes) { [ActionSucceeded.new, ActionSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(term_xor)
    end
  end
end
