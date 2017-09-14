require 'timecop'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/expiration'

include AI::Actions

RSpec.describe AI::Behaviors::Expiration do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:node) { ActionSucceeded.new({}) }
  let(:expires) { 3 }
  let(:expiration) { AI::Behaviors::Expiration.new(node: node, expires: expires) }

  describe '#initialize' do
    subject { expiration }

    it 'node and expires should be set' do
      expect(subject.node).to eq(node)
      expect(subject.expires).to eq(expires)
    end

    context 'expires not set' do
      let(:expires) { nil }

      it 'should raise ArgumentError expires not set' do
        expect { subject }.to raise_error(ArgumentError, ':expires not set')
      end
    end
  end

  describe '#process' do
    subject { expiration }

    before { expiration.start! }

    context 'when doing 2 loops of ActionSucceeded and maximum equals to 3' do
      # TODO: test when node is busy
      it 'should have succeeded' do
        1.upto(2) do
          expiration.process(entity, world)

          Timecop.travel(Time.now + 1)
        end

        expect(subject.succeeded?).to eq(true)

        Timecop.return
      end
    end

    context 'when doing 5 loops of ActionSucceeded but maximum equals to 3' do
      let(:node) { ActionBusy.new({}) }

      it 'should have failed' do
        1.upto(5) do
          expiration.process(entity, world)

#          expect(expiration.elapsed).to eq(Time.now - expiration.start_time)

          Timecop.travel(Time.now + 1)
        end

        expect(subject.node.stopped?).to eq(true)
        expect(subject.failed?).to eq(true)

        Timecop.return
      end
    end

    it 'returns self' do
      expect(subject).to eq(expiration)
    end
  end
end
