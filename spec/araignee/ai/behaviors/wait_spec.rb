require 'timecop'
require 'araignee/ai/behaviors/wait'

RSpec.describe AI::Behaviors::Wait do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  let(:delay) { 3 }
  let(:wait) { AI::Behaviors::Wait.new(delay: delay) }

  describe '#start' do
    context 'when wait is not set' do
      let(:wait) { AI::Behaviors::Wait.new }

      it 'should raise ArgumentError delay must be > 0' do
        expect { wait.start! }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end
  end

  describe '#process' do
    before { wait.start! }
    subject { wait.process(entity, world) }

    context 'when wait of 3 seconds' do
      context 'before wait expires' do
        it 'should be running' do
          Timecop.travel(Time.now + 1)

          expect(subject.running?).to eq(true)

          Timecop.return
        end
      end

      context 'after wait expires' do
        it 'should have succeeded' do
          Timecop.travel(Time.now + 5)

          expect(subject.succeeded?).to eq(true)

          Timecop.return
        end
      end
    end

    it 'returns self' do
      expect(subject).to eq(wait)
    end
  end
end
