require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/succeeder'

include AI::Actions

RSpec.describe AI::Behaviors::Succeeder do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:node) { ActionSucceeded.new({}) }
  let(:succeeder) { AI::Behaviors::Succeeder.new(node: node) }

  describe '#process' do
    subject { succeeder.process(entity, world) }
    before { succeeder.start! }

    context 'when node is not running' do
      before { node.stop! }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionSucceeded' do
      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed' do
      let(:node) { ActionFailed.new({}) }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(succeeder)
    end
  end
end
