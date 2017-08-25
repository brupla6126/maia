require 'araignee/ai/actions/failed'
require 'araignee/ai/behaviors/repeater'
require 'araignee/ai/behaviors/repetition/repeat_until_failure'

include AI::Actions

RSpec.describe AI::Behavior::Repetition::RepeatUntilFailure do
  class RepeaterUntilFailure < AI::Behaviors::Repeater
    include AI::Behavior::Repetition::RepeatUntilFailure
  end

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionTemporaryFailed.new(times: 3) }
  let(:repeater) { RepeaterUntilFailure.new(node: node) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { repeater.fire_state_event(:start) }
    subject { repeater.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end

    it 'returns self' do
      expect(subject).to eq(repeater)
    end
  end
end
