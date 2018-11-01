require 'timecop'
require 'araignee/ai/core/timeout'

RSpec.describe Araignee::Ai::Core::Timeout do
  let(:delay) { 3 }
  let(:start_time) { Time.parse('2018-01-01 01:01:01') }

  let(:timeout) { described_class.new(delay: delay) }

  before do
    timeout.state = initial_state(start_time: start_time, delay: delay)
  end

  subject { timeout }

  describe '#reset' do
    subject { super().reset }

    let(:now) { Time.parse('2018-12-12 12:12:12') }

    it 'resets start_time' do
      Timecop.freeze(now) do
        subject
        expect(timeout.state.start_time).to eq(now)
      end
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when delay of 3 seconds' do
      let(:start_time) { Time.now }

      after { Timecop.return }

      context 'before timeout expires' do
        it 'is busy' do
          Timecop.travel(Time.now + 1)

          expect(subject.busy?).to eq(true)
        end
      end

      context 'after timeout expires' do
        it 'has failed' do
          Timecop.travel(Time.now + 5)

          expect(subject.failed?).to eq(true)
        end
      end
    end

    context 'invalid delay' do
      let(:delay) { 0 }

      it 'raises ArgumentError delay must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end

    context 'valid delay' do
      let(:delay) { 3 }

      it 'does not raise ArgumentError' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
