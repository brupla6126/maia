require 'araignee/ai/actions/failed'
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

  before do
    allow(world).to receive(:delta) { 1 }
  end

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

  describe '#start' do
    subject { condition.fire_state_event(:start) }

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

  describe '#process' do
    context 'when term resolve to true' do
      let(:term) { ActionSucceeded.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      before { condition.fire_state_event(:start) }
      subject { condition.process(entity, world) }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when term resolve to false' do
      let(:term) { ActionFailed.new }
      let(:yes) { ActionSucceeded.new }
      let(:no) { ActionFailed.new }

      before { condition.fire_state_event(:start) }
      subject { condition.process(entity, world) }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
