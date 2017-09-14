require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/actions/probability'
require 'araignee/ai/behaviors/balancer'

include AI::Actions
include AI::Behaviors

RSpec.describe AI::Behaviors::Balancer do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:nodes) { [] }
  let(:balancer) { AI::Behaviors::Balancer.new(nodes: nodes) }

  describe '#process' do
    subject { balancer.process(entity, world) }

    before { balancer.start! }

    let(:nodes) { [ActionLuckiest.new({}), ActionLooser.new({}), ActionBummer.new({})] }

    context 'when not derived' do
      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      it 'should have succeeded' do
        allow(balancer).to receive(:pick_node) { nodes.first }

        expect(subject.succeeded?).to eq(true)
      end
    end

#    context 'when running nodes selected' do
#    end

    context 'when no node was picked' do
      it 'should have succeeded' do
        allow(balancer).to receive(:pick_node) { nil }

        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when no node was picked' do
      let(:nodes) { [ActionSucceeded.new({}), ActionBusy.new({}), ActionFailed.new({})] }

      context 'executed node state is succeeded' do
        it 'should have succeeded' do
          allow(balancer).to receive(:pick_node) { nodes[0] }
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'executed node state is busy' do
        it 'should have busy' do
          allow(balancer).to receive(:pick_node) { nodes[1] }
          expect(subject.busy?).to eq(true)
        end
      end

      context 'executed node state is failed' do
        it 'should have failed' do
          allow(balancer).to receive(:pick_node) { nodes[2] }
          expect(subject.failed?).to eq(true)
        end
      end
    end

    it 'returns self' do
      allow(balancer).to receive(:pick_node) { nodes.first }

      expect(subject).to eq(balancer)
    end
  end
end
