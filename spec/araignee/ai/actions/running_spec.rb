require 'araignee/ai/actions/running'

include AI::Actions

RSpec.describe AI::Actions::ActionRunning do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action) { ActionRunning.new }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { action.start! }
    subject { action.process(entity, world) }

    it 'should be running' do
      expect(subject.running?).to eq(true)
    end
  end
end
