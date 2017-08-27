require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/actions/probability'
require 'araignee/ai/behaviors/balancer'

include AI::Actions
include AI::Behaviors

RSpec.describe AI::Behaviors::Balancer do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:nodes) { [] }
  let(:balancer) { AI::Behaviors::Balancer.new(nodes: nodes) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { balancer.start! }

    let(:nodes) { [ActionLuckiest.new, ActionLooser.new, ActionBummer.new] }

    subject { balancer.process(entity, world) }

    context 'when not derived' do
      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      it 'should have succeeded' do
        allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes.first)

        expect(subject.started?).to eq(true)
      end
    end

    context 'when no node was picked' do
      it 'should have succeeded' do
        allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nil)

        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when no node was picked' do
      let(:nodes) { [ActionSucceeded.new, ActionRunning.new, ActionFailed.new] }

      context 'executed node state is succeeded' do
        it 'should have succeeded' do
          allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes[0])
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'executed node state is running' do
        it 'should have running' do
          allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes[1])
          expect(subject.running?).to eq(true)
        end
      end

      context 'executed node state is failed' do
        it 'should have failed' do
          allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes[2])
          expect(subject.failed?).to eq(true)
        end
      end
    end

    it 'returns self' do
      allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes.first)

      expect(subject).to eq(balancer)
    end
  end
end
