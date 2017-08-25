require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Actions::Action do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action) { ActionSucceeded.new }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { action.fire_state_event(:start) }
    subject { action.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
