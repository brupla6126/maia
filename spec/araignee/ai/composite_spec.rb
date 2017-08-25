require 'araignee/ai/composite'
require 'araignee/ai/actions/succeeded'

RSpec.describe AI::Composite do
  let(:nodes) { [] }
  let(:composite) { AI::Composite.new(nodes: nodes) }

  describe '#initialize' do
    context 'when initializing without children nodes' do
      it 'should  have no children' do
        expect(composite.nodes.count).to eq(0)
      end
    end

    context 'when initializing with nodes' do
      let(:child1) { AI::Node.new }
      let(:child2) { AI::Node.new }
      let(:nodes) { [child1, child2] }

      it 'should have set children nodes' do
        expect(composite.nodes.size).to eq(2)
        expect(composite.nodes[0]).to eq(child1)
        expect(composite.nodes[1]).to eq(child2)
      end
    end
  end

  describe '#start' do
    context 'children nodes set' do
      let(:nodes) { [ActionSucceeded.new] }

      before { composite.fire_state_event(:start) }

      it 'composite should be running' do
        expect(composite.running?).to eq(true)
      end

      it 'children nodes should be running' do
        nodes.each { |node| expect(node.running?).to eq(true) }
      end
    end
  end

  describe '#add_node' do
    let(:child1) { AI::Node.new }
    let(:child2) { AI::Node.new }
    let(:nodes) { [child1, child2] }

    let(:added_node) { AI::Node.new }
    let(:index) { :last }

    before { composite.add_node(added_node, index) }
    subject { composite.nodes }

    it 'should have all nodes' do
      expect(subject.count).to eq(3)
    end

    context 'when insert at last position' do
      it 'should have inserted' do
        expect(subject[subject.count - 1]).to eq(added_node)
      end
    end

    context 'when insert at specified position' do
      let(:index) { 1 }

      it 'should have inserted' do
        expect(subject[index]).to eq(added_node)
      end
    end
  end

  describe '#remove_node' do
    let(:child1) { AI::Node.new }
    let(:nodes) { [child1] }

    let(:removed_node) { child1 }

    before { composite.remove_node(removed_node) }
    subject { composite.nodes }

    it 'should have all nodes' do
      expect(subject.count).to eq(0)
    end
  end
end
