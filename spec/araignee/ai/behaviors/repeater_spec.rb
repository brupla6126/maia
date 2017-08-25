require 'araignee/ai/actions/failed'
require 'araignee/ai/behaviors/repeater'

include AI::Actions

RSpec.describe AI::Behaviors::Repeater do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionFailed.new }
  let(:times) { nil }
  let(:repeater) { AI::Behaviors::Repeater.new(node: node, times: times) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#start' do
    before { repeater.fire_state_event(:start) }

    context 'when decorated node valid' do
      it 'should be running' do
        expect(repeater.running?).to eq(true)
      end

      it 'child node should be running' do
        expect(repeater.node.running?).to eq(true)
      end
    end
  end

  describe '#process' do
    before { repeater.fire_state_event(:start) }
    subject { repeater.process(entity, world) }

    context 'when decorated node valid' do
      it 'should be running' do
        expect(subject.running?).to eq(true)
      end

      it 'child node should be running' do
        expect(subject.node.running?).to eq(true)
      end
    end

    # TODO: test repeat_progress not called when @node not running

    it 'returns self' do
      expect(subject).to eq(repeater)
    end
  end
end
