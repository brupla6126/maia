require 'timecop'
require 'araignee/ai/core/wait'

RSpec.describe Araignee::Ai::Core::Wait do
  let(:wait) { described_class.new }
  let(:delay) { 3 }
  let(:start_time) { Time.parse('2018-11-11 11:11:11') }

  before do
    wait.state = initial_state(start_time: start_time, delay: delay)
  end

  subject { wait }

  describe '#reset' do
    subject { super().reset }

    let(:now) { Time.parse('2018-12-12 12:12:12') }

    it 'resets start_time' do
      Timecop.freeze(now) do
        subject
        expect(wait.state.start_time).to eq(now)
      end
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'invalid delay' do
      let(:delay) { 0 }

      it 'should raise ArgumentError delay must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end

    context 'valid delay' do
      let(:delay) { 3 }

      it 'does not raise ArgumentError delay must be > 0' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when wait of 3 seconds' do
      let(:start_time) { Time.now }

      after { Timecop.return }

      context 'before wait expires' do
        it 'is busy' do
          Timecop.travel(Time.now + 1)

          expect(subject.busy?).to eq(true)
        end
      end

      context 'after wait expires' do
        it 'has succeeded' do
          Timecop.travel(Time.now + 5)

          expect(subject.succeeded?).to eq(true)
        end
      end
    end
  end
end
