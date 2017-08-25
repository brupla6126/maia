require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/repeater'
require 'araignee/ai/behaviors/repetition/repeat_number_times'

RSpec.describe AI::Behaviors::Repetition::RepeatNumberTimes do
  class RepetitionNumberTimes < AI::Behaviors::Repeater
    include AI::Behaviors::Repetition::RepeatNumberTimes
  end

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionSucceeded.new }
  let(:times) { 5 }
  let(:repetition) { RepetitionNumberTimes.new(node: node, times: times) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#repeat_process' do
    before { repetition.fire_state_event(:start) }
    subject { repetition.repeat_process(entity, world) }

    context 'number of times negative' do
      let(:times) { -2 }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'times must be >= 0')
      end
    end

    context 'number of times >= 0' do
      before do
        allow(node).to receive(:process).and_return(node)
        allow(node).to receive(:succeeded?).and_return(true)
      end

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end

      it 'node#process should be called specified number of times' do
        expect(subject.node).to have_received(:process).at_least(times).times
      end
    end

    it 'returns self' do
      expect(subject).to eq(repetition)
    end
  end
end
