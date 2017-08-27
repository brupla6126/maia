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
  let(:condition) { AI::Behaviors::Condition.new(term: term, yes: yes, no: no) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#initialize' do
    context 'when term, yes and no are set' do
      let(:term) { ActionFailed.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      it 'term, yes, no should be set' do
        expect(condition.term).to eq(term)
        expect(condition.yes).to eq(yes)
        expect(condition.no).to eq(no)
      end
    end
  end

  describe '#start!' do
    subject { condition.start! }

    context 'when term is not set' do
      let(:term) { nil }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      it 'should raise ArgumentError term is nil' do
        expect { subject }.to raise_error(ArgumentError, 'term nil')
      end
    end

    context 'when yes is not set' do
      let(:term) { ActionSucceeded.new }
      let(:yes) { nil }
      let(:no) { ActionFailed.new }

      it 'should raise ArgumentError yes is nil' do
        expect { subject }.to raise_error(ArgumentError, 'yes nil')
      end
    end

    context 'when no is not set' do
      let(:term) { ActionSucceeded.new }
      let(:yes) { ActionFailed.new }
      let(:no) { nil }

      it 'should raise ArgumentError no is nil' do
        expect { subject }.to raise_error(ArgumentError, 'no nil')
      end
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
