require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/selector'

include AI::Actions

RSpec.describe AI::Behaviors::Selector do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:nodes) { [ActionSucceeded.new] }
  let(:selector) { AI::Behaviors::Selector.new(nodes: nodes) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#initialize' do
    context 'when given nodes' do
      it 'should have children nodes set' do
        expect(selector.nodes).to eq(nodes)
      end
    end
  end

  describe '#process' do
    before { selector.start! }
    subject { selector.process(entity, world) }

    context 'when ActionSucceeded' do
      let(:nodes) { [ActionSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionSucceeded' do
      let(:nodes) { [ActionFailed.new, ActionFailed.new, ActionSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionRunning' do
      let(:nodes) { [ActionFailed.new, ActionRunning.new] }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed' do
      let(:nodes) { [ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(selector)
    end
  end
end
