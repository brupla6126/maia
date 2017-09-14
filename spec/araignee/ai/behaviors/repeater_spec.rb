require 'araignee/ai/actions/failed'
require 'araignee/ai/behaviors/repeater'

include AI::Actions

RSpec.describe AI::Behaviors::Repeater do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:node) { ActionFailed.new({}) }
  let(:times) { nil }
  let(:repeater) { AI::Behaviors::Repeater.new(node: node, times: times) }

  describe '#process' do
    subject { repeater.process(entity, world) }

    before { repeater.start! }

    context 'when decorated node valid' do
    end

    # TODO: test repeat_progress not called when @node not running

    it 'returns self' do
      expect(subject).to eq(repeater)
    end
  end
end
