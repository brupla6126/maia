require 'timecop'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/expiration'

include AI::Actions

RSpec.describe AI::Behaviors::Expiration do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionSucceeded.new }
  let(:expires) { 5 }
  let(:expiration) { AI::Behaviors::Expiration.new(node: node, expires: expires) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#initialize' do
    context 'when expires is not set' do
      it 'node and expires should be set' do
        expect(expiration.node).to eq(node)
        expect(expiration.expires).to eq(expires)
      end
    end
  end

  describe '#start' do
    context 'when expires is not set' do
      let(:expires) { nil }

      it 'should raise ArgumentError expires not set' do
        expect { expiration.fire_state_event(:start) }.to raise_error(ArgumentError, ':expires not set')
      end
    end
  end

  describe '#process' do
    let(:expires) { 3 }

    before { expiration.fire_state_event(:start) }

    context 'when doing 2 loops of ActionSucceeded and maximum equals to 3' do
      subject { expiration.succeeded? }

      it 'should have succeeded' do
        1.upto(2) do
          expiration.process(entity, world)

          Timecop.travel(Time.now + 1)
        end

        expect(subject).to eq(true)

        Timecop.return
      end
    end

    context 'when doing 5 loops of ActionSucceeded but maximum equals to 3' do
      let(:node) { ActionRunning.new }

      subject { expiration.failed? }

      it 'should have failed' do
        1.upto(5) do
          expiration.process(entity, world)

          Timecop.travel(Time.now + 1)
        end

        expect(subject).to eq(true)

        Timecop.return
      end
    end
  end
end
