require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Actions::Action do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action) { ActionSucceeded.new }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { action.start! }
    subject { action.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
