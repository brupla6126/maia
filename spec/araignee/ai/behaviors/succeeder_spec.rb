require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/succeeder'

include AI::Actions

RSpec.describe AI::Behaviors::Succeeder do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { ActionSucceeded.new }
  let(:succeeder) { AI::Behaviors::Succeeder.new(node: node) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { succeeder.fire_state_event(:start) }
    subject { succeeder.process(entity, world) }

    context 'when node is not running' do
      let(:node) { ActionSucceeded.new }
      before { node.fire_state_event(:cancel) }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionSucceeded' do
      let(:node) { ActionSucceeded.new }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed' do
      let(:node) { ActionFailed.new }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    # TODO: test @node.process not called when !@node.running?

    it 'returns self' do
      expect(subject).to eq(succeeder)
    end
  end
end
