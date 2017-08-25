require 'araignee/ai/actions/probability'
require 'araignee/ai/behaviors/balancer'

include AI::Actions
include AI::Behaviors

RSpec.describe AI::Behaviors::Balancer do
  let(:world) { double('[world]') }
  let(:entity) { {} }

  let(:nodes) { [] }
  let(:balancer) { Balancer.new(nodes: nodes) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { balancer.fire_state_event(:start) }

    let(:nodes) { [ActionLuckiest.new, ActionLooser.new, ActionBummer.new] }

    subject { balancer.process(entity, world) }

    it 'nodes are running' do
      nodes.each { |node| expect(node.running?).to eq(true) }
    end

    context 'when not derived' do
      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      it 'should have succeeded' do
        allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes.first)

        expect(subject.running?).to eq(true)
      end
    end

    context 'when no node was picked' do
      it 'should have succeeded' do
        allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nil)

        expect(subject.succeeded?).to eq(true)
      end
    end

    it 'returns self' do
      allow_any_instance_of(Balancer).to receive(:pick_node).and_return(nodes.first)

      expect(subject).to eq(balancer)
    end
  end
end
