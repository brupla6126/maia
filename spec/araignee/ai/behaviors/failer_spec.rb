require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/failer'

include AI::Actions

RSpec.describe AI::Behaviors::Failer do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:failer) { AI::Behaviors::Failer.new(node: node) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    let(:node) { ActionSucceeded.new }

    before { failer.start! }

    subject { failer.process(entity, world) }

    context 'when ActionSucceeded' do
      before { allow(node).to receive(:process).with(entity, world) }

      it 'child node should be processed' do
        expect(node).to receive(:process).with(entity, world)
        subject
      end

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionFailed' do
      let(:node) { ActionFailed.new }

      it 'child node should be processed' do
        expect(node).to receive(:process).with(entity, world)
        subject
      end

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(failer)
    end
  end
end
