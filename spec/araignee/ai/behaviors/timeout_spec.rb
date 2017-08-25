require 'timecop'
require 'araignee/ai/behaviors/timeout'

include AI::Actions

RSpec.describe AI::Behaviors::Timeout do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:delay) { 3 }
  let(:timeout) { AI::Behaviors::Timeout.new(delay: delay) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#start' do
    context 'when delay is not set' do
      let(:timeout) { AI::Behaviors::Timeout.new }

      it 'should raise ArgumentError delay must be > 0' do
        expect { timeout.fire_state_event(:start) }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end
  end

  describe '#process' do
    before { timeout.fire_state_event(:start) }
    subject { timeout.process(entity, world) }

    context 'when delay of 3 seconds' do
      context 'before timeout expires' do
        it 'should be running' do
          Timecop.travel(Time.now + 1)

          expect(subject.running?).to eq(true)

          Timecop.return
        end
      end

      context 'after timeout expires' do
        it 'should have failed' do
          Timecop.travel(Time.now + 5)

          expect(subject.failed?).to eq(true)

          Timecop.return
        end
      end
    end

    it 'returns self' do
      expect(subject).to eq(timeout)
    end
  end
end
