require 'araignee/ai/actions/stopped'

include AI::Actions

RSpec.describe AI::Actions::ActionStopped do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  let(:action) { ActionStopped.new }

  describe '#process' do
    before { action.start! }
    subject { action.process(entity, world) }

    it 'should have been stopped' do
      expect(subject.stopped?).to eq(true)
    end
  end
end
