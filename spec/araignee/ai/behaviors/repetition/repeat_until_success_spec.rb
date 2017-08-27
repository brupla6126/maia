require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/repeater'
require 'araignee/ai/behaviors/repetition/repeat_until_success'

include AI::Actions

RSpec.describe AI::Behavior::Repetition::RepeatUntilSuccess do
  class RepeaterUntilSuccess < AI::Behaviors::Repeater
    include AI::Behavior::Repetition::RepeatUntilSuccess
  end

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionTemporarySucceeded.new(times: 3) }
  let(:repeater) { RepeaterUntilSuccess.new(node: node) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { repeater.start! }
    subject { repeater.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end

    it 'returns self' do
      expect(subject).to eq(repeater)
    end
  end
end
