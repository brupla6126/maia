require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/condition'

include AI::Actions

RSpec.describe AI::Behaviors::Condition do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:term) { ActionFailed.new }
  let(:yes) { ActionSucceeded.new }
  let(:no) { ActionFailed.new }
  let(:nodes) { [term, yes, no] }

  let(:condition) { AI::Behaviors::Condition.new(nodes: nodes) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#initialize' do
    context 'when term, yes and no are set' do
      let(:term) { ActionFailed.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      it 'term, yes, no should be set' do
        expect(condition.child(term.identifier)).to eq(term)
        expect(condition.child(yes.identifier)).to eq(yes)
        expect(condition.child(no.identifier)).to eq(no)
      end
    end
  end

  describe '#start!' do
    before { condition.start! }

    it 'condition should be started' do
      expect(condition.started?).to eq(true)
    end
  end

  describe '#stop!' do
    before { condition.start! }
    before { condition.stop! }

    it 'condition should be stopped' do
      expect(condition.stopped?).to eq(true)
    end

    it 'term, yes, no should be stopped' do
      expect(term.stopped?).to eq(true)
      expect(yes.stopped?).to eq(true)
      expect(no.stopped?).to eq(true)
    end
  end

  describe '#process' do
    before { condition.start! }
    subject { condition.process(entity, world) }

    context 'when term resolve to true' do
      let(:term) { ActionSucceeded.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when term resolve to false' do
      let(:term) { ActionFailed.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when executed node state is running' do
      let(:term) { ActionSucceeded.new }
      let(:yes) { ActionRunning.new }
      let(:no) { ActionFailed.new }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end
  end
end
