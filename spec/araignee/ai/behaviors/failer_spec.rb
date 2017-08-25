require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/failer'

include AI::Actions

RSpec.describe AI::Behaviors::Failer do

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:node) { nil }
  let(:failer) { AI::Behaviors::Failer.new(node: node) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { failer.fire_state_event(:start) }
    subject { failer.process(entity, world).failed? }

    context 'when ActionSucceeded' do
      let(:node) { ActionSucceeded.new }

      it 'should have failed' do
        expect(subject).to eq(true)
      end
    end

    context 'when ActionFailed' do
      let(:node) { ActionFailed.new }

      it 'should have failed' do
        expect(subject).to eq(true)
      end
    end
  end
end
