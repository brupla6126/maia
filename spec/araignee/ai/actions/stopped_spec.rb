require 'araignee/ai/actions/stopped'

include AI::Actions

RSpec.describe AI::Actions::ActionStopped do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  let(:action) { ActionStopped.new({}) }

  describe '#process' do
    subject { action.process(entity, world) }

    before { action.start! }

    context 'before process' do
      it 'should NOT be stopped' do
        expect(action.stopped?).to eq(false)
      end
    end

    context 'after process' do
      before { allow(action).to receive(:can_stop?) { true } }

      it 'should have been stopped' do
        expect(action).to receive(:can_stop?)
        expect(subject.stopped?).to eq(true)
      end
    end

    it 'node @elapsed should be updated' do
      expect(subject.elapsed).to eq(1)
    end

    it 'returns self' do
      expect(subject).to eq(action)
    end
  end
end
