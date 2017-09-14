require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/selector'

include AI::Actions

RSpec.describe AI::Behaviors::Selector do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:nodes) { [ActionSucceeded.new({})] }
  let(:selector) { AI::Behaviors::Selector.new(nodes: nodes) }

  describe '#initialize' do
    subject { selector }

    it 'should have children nodes set' do
      expect(subject.nodes).to eq(nodes)
    end
  end

  describe '#process' do
    subject { selector.process(entity, world) }
    before { selector.start! }

    context 'when ActionSucceeded' do
      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionSucceeded' do
      let(:nodes) { [ActionFailed.new({}), ActionFailed.new({}), ActionSucceeded.new({})] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionBusy' do
      let(:nodes) { [ActionFailed.new({}), ActionBusy.new({})] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed' do
      let(:nodes) { [ActionFailed.new({}), ActionFailed.new({})] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(selector)
    end
  end
end
