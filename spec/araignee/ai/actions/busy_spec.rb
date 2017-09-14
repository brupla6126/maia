require 'araignee/ai/actions/busy'

include AI::Actions

RSpec.describe AI::Actions::ActionBusy do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }
  before { allow(world).to receive(:delta) { 1 } }

  let(:action) { ActionBusy.new({}) }

  describe '#process' do
    subject { action.process(entity, world) }

    before { action.start! }

    context 'before process' do
      it 'should NOT be busy' do
        expect(action.busy?).to eq(false)
      end
    end

    context 'after process' do
      it 'should be busy' do
        expect(subject.busy?).to eq(true)
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
