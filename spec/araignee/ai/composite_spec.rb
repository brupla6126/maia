require 'araignee/ai/composite'
require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Composite do
  let(:child1) { AI::Node.new({}) }
  let(:child2) { AI::Node.new({}) }
  let(:nodes) { [child1, child2] }
  let(:attributes) { { nodes: nodes } }
  let(:composite) { AI::Composite.new(attributes) }

  before { Log[:ai] = double('Log[:ai] start!') }
  before { allow(Log[:ai]).to receive(:debug) }
  before { allow(Log[:ai]).to receive(:warn) }
  after { Log[:ai] = Log[:default] }

  subject { composite }

  describe '#initialize' do
    context 'with attributes nil' do
      let(:attributes) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'attributes of invalid type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'with attributes empty' do
      let(:attributes) { {} }

      it 'should raise ArgumentError nodes must be Array of AI::Node' do
        expect { subject }.to raise_error(ArgumentError, 'nodes must be Array')
      end
    end

    context 'with attributes' do
      # make sure it calls super()
      context 'invalid identifier' do
        let(:identifier) { AI::Node.new({}) }

        before { attributes[:identifier] = identifier }

        it 'should raise ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, "invalid identifier: #{identifier}")
        end
      end

      context 'without nodes' do
        let(:attributes) { { nodes: [] } }

        it 'should raise ArgumentError nodes must be Array of AI::Node' do
          expect { subject }.to raise_error(ArgumentError, 'nodes must be Array')
        end
      end

      context 'with nodes' do
        let(:child1) { AI::Node.new({}) }
        let(:child2) { AI::Node.new({}) }
        let(:nodes) { [child1, child2] }

        it 'should have set children nodes' do
          expect(subject.nodes.size).to eq(2)
          expect(subject.nodes[0]).to eq(child1)
          expect(subject.nodes[1]).to eq(child2)
        end

        it 'identifier should not be nil' do
          expect(subject.identifier).to be_a(String)
        end

        it 'state should be ready' do
          expect(subject.ready?).to eq(true)
        end

        it 'response should be :unknown' do
          expect(subject.response).to eq(:unknown)
        end

        it 'elapsed should equal 0' do
          expect(subject.elapsed).to eq(0)
        end

        it 'parent should equal nil' do
          expect(subject.parent).to eq(nil)
        end

        it 'composite should be ready' do
          expect(subject.ready?).to eq(true)
        end

        it 'children nodes should be ready' do
          nodes.each { |node| expect(node.ready?).to eq(true) }
        end
      end
    end
  end

  describe '#child' do
    let(:child1) { AI::Node.new({}) }
    let(:child2) { AI::Node.new({}) }
    let(:child3) { AI::Node.new(identifier: child1.identifier) }
    let(:nodes) { [child1, child2, child3] }

    let(:child_identifier) { child1.identifier }

    subject { composite.child(child_identifier) }

    it 'should find child node' do
      expect(subject).to eq(child1)
    end

    context 'unknown node' do
      let(:child_identifier) { 'abcdef' }

      it 'should not find child node' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#add_node' do
    let(:child1) { AI::Node.new({}) }
    let(:child2) { AI::Node.new({}) }
    let(:nodes) { [child1, child2] }

    let(:added_node) { AI::Node.new({}) }
    let(:index) { :last }

    it 'should have all nodes' do
      expect(subject.nodes.count).to eq(2)
    end

    context 'invalid index' do
      context 'with wrong symbol' do
        let(:index) { :last_index }

        it 'should raise ArgumentError' do
          expect { subject.add_node(added_node, index) }.to raise_error(ArgumentError, "invalid index: #{index}")
        end
      end

      context 'with String' do
        let(:index) { "1" }

        it 'should raise ArgumentError' do
          expect { subject.add_node(added_node, index) }.to raise_error(ArgumentError, "invalid index: #{index}")
        end
      end

      context 'with nil' do
        let(:index) { nil }

        before { subject.add_node(added_node, index) }

        it 'should insert at last position' do
          expect(subject.nodes[subject.nodes.count - 1]).to eq(added_node)
        end
      end
    end

    context 'valid index' do
      it 'should not raise ArgumentError' do
        expect { subject.add_node(added_node, index) }.not_to raise_error
      end

      context 'when insert at last position' do
        before { subject.add_node(added_node, index) }

        it 'should have inserted' do
          expect(subject.nodes[subject.nodes.count - 1]).to eq(added_node)
          expect(subject.nodes.count).to eq(3)
        end
      end

      context 'when insert at specified position' do
        let(:index) { 1 }

        before { subject.add_node(added_node, index) }

        it 'should have inserted' do
          expect(subject.nodes[index]).to eq(added_node)
          expect(subject.nodes.count).to eq(3)
        end
      end
    end
  end

  describe '#remove_node' do
    let(:child1) { AI::Node.new({}) }
    let(:nodes) { [child1] }

    let(:removed_node) { child1 }

    before { composite.remove_node(removed_node) }
    subject { composite.nodes }

    it 'should have no nodes' do
      expect(subject.count).to eq(0)
    end
  end

  describe 'node_starting' do
    context 'without children nodes' do
      let(:nodes) { [] }

      after { subject.start! }

    end

    context 'with children nodes' do
      let(:nodes) { [ActionSucceeded.new(elapsed: 4)] }

      before { subject.start! }

      it 'should not log warning composite has no children' do
        expect(Log[:ai]).not_to receive(:warn)
      end

      it 'composite should be running and call Log[:ai].debug' do
        expect(subject.running?).to eq(true)
        expect(Log[:ai]).to have_received(:debug).exactly(4).times
      end

      it 'children nodes should be running' do
        nodes.each do |node|
          expect(node.running?).to eq(true)
          expect(node.elapsed).to eq(0)
        end
      end
    end
  end

  describe 'reset_node' do
    context 'returned value' do
      it 'should return nil' do
        expect(subject.send(:reset_node)).to eq(nil)
      end
    end

    context 'composite' do
      after { subject.send(:reset_node) }

      it 'should call reset_attribute on composite' do
        expect(subject).to receive(:reset_attribute).with(:elapsed)
      end
    end

    context 'reset_attribute' do
      let(:child1) { double('[child1]') }
      let(:nodes) { [child1] }

      before { allow(child1).to receive(:reset_node) }

      after { subject.send(:reset_node) }

      it 'should call reset_attribute on composite' do
        expect(subject).to receive(:reset_attribute).with(:elapsed)
      end

      it 'should call reset_attribute on each child node' do
        nodes.each { |node| expect(node).to receive(:reset_node) }
      end
    end
  end

  describe 'node_stopping' do
    context 'children nodes set' do
      let(:nodes) { [ActionSucceeded.new({})] }

      before { subject.start! }
      before { subject.stop! }

      it 'composite should be stopped and call Log[:ai].debug' do
        expect(subject.stopped?).to eq(true)
        expect(Log[:ai]).to have_received(:debug).exactly(8).times
      end

      it 'children nodes should be stopped' do
        nodes.each { |node| expect(node.stopped?).to eq(true) }
      end
    end
  end

=begin
  describe 'validate_attributes' do
    context 'without children nodes' do
      let(:nodes) { [] }

      it 'should raise ArgumentError nodes must be Array of AI::Node' do
        expect { subject }.to raise_error(ArgumentError, 'nodes must be Array of AI::Node')
      end
    end

    context 'with children nodes' do
      let(:nodes) { [ActionSucceeded.new({})] }

      it 'should not log warning composite has no children' do
        expect(Log[:ai]).not_to receive(:warn)
      end
    end
  end
=end
end
