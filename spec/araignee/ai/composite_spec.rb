require 'araignee/ai/composite'
require 'araignee/ai/fabricators/ai_node_fabricator'

RSpec.describe AI::Composite do
  let(:child1) { Fabricate(:ai_node) }
  let(:child2) { Fabricate(:ai_node) }
  let(:children) { [child1, child2] }
  let(:composite) { Fabricate(:ai_composite, children: children) }

  before { Log[:ai] = double('Log[:ai]') }
  before { allow(Log[:ai]).to receive(:debug) }
  after { Log[:ai] = Log[:default] }

  subject { composite }

  describe '#initialize' do
    it 'composite is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end

    it 'children are set' do
      expect(subject.children).to eq(children)
    end

    it 'children are ready' do
      children.each { |child| expect(child.ready?).to eq(true) }
    end

    it 'children response are :unknown' do
      children.each { |child| expect(child.response).to eq(:unknown) }
    end
  end

  describe '#child' do
    let(:child1) { Fabricate(:ai_node) }
    let(:child2) { Fabricate(:ai_node) }
    let(:child3) { Fabricate(:ai_node, identifier: child1.identifier) }
    let(:children) { [child1, child2, child3] }

    let(:child_identifier) { child1.identifier }

    subject { composite.child(child_identifier) }

    it 'finds child' do
      expect(subject).to eq(child1)
    end

    context 'unknown child' do
      let(:child_identifier) { 'abcdef' }

      it 'does not find child' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#add_child' do
    subject { super().add_child(added_child, index) }

    let(:added_child) { Fabricate(:ai_node) }
    let(:index) { :last }

    it 'should have all children' do
      expect(subject.children.count).to eq(3)
    end

    context 'invalid index' do
      context 'with wrong symbol' do
        let(:index) { :last_index }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, "invalid index: #{index}")
        end
      end

      context 'with String' do
        let(:index) { '1' }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, "invalid index: #{index}")
        end
      end

      context 'with nil' do
        let(:index) { nil }

        it 'inserts at last position' do
          expect(subject.children[subject.children.count - 1]).to eq(added_child)
        end
      end
    end

    context 'valid index' do
      it 'does not raise ArgumentError' do
        expect { subject }.not_to raise_error
      end

      context 'when insert at last position' do
        it 'inserts at last position' do
          expect(subject.children[subject.children.count - 1]).to eq(added_child)
          expect(subject.children.count).to eq(3)
        end
      end

      context 'when insert at specified position' do
        let(:index) { 1 }

        it 'inserts at specified position' do
          expect(subject.children[index]).to eq(added_child)
          expect(subject.children.count).to eq(3)
        end
      end
    end
  end

  describe '#remove_child' do
    subject { composite.remove_child(removed_child) }

    context 'known child' do
      let(:child) { Fabricate(:ai_node) }
      let(:children) { [child] }

      let(:removed_child) { child }

      it 'removes child' do
        expect(subject.children.include?(child)).to eq(false)
      end
    end

    context 'unknown child' do
      let(:child) { Fabricate(:ai_node) }
      let(:unknown) { Fabricate(:ai_node) }
      let(:children) { [child] }

      let(:removed_child) { unknown }

      it 'does not remove' do
        expect(subject.children.count).to eq(1)
      end
    end
  end

  describe 'reset_node' do
    subject { super().reset_node }

    after { subject }

    context 'returned value' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    it 'reset response attribute' do
      expect(composite).to receive(:reset_attribute).with(:response)
    end

    context 'children' do
      let(:child) { double('[child]') }
      let(:children) { [child] }

      before { allow(child).to receive(:validate_attributes) }
      before { allow(child).to receive(:reset_node) }

      it 'calls reset_node on each child' do
        expect(child).to receive(:reset_node)
      end
    end
  end

  describe 'node_starting' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.children[0].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.children[0].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.children[1].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.children[1].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }

      subject.start!
    end

    context 'without children' do
      let(:children) { [] }

      after { subject.start! }
    end

    context 'with children' do
      let(:children) { [Fabricate(:ai_node)] }

      before do
        children.each { |child| allow(child).to receive(:validate_attributes) }
      end

      before { subject.start! }

      it 'composite is running' do
        expect(subject.running?).to eq(true)
      end

      it 'children are running' do
        children.each { |child| expect(child.running?).to eq(true) }
      end

      it 'children attributes are validated' do
        children.each { |child| expect(child).to have_received(:validate_attributes) }
      end
    end
  end

  describe 'node_stopping' do
    before { subject.start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.children[0].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.children[0].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.children[1].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.children[1].inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.inspect}") }

      subject.stop!
    end

    context 'children set' do
      let(:children) { [Fabricate(:ai_node)] }

      before { subject.stop! }

      it 'composite is stopped' do
        expect(subject.stopped?).to eq(true)
      end

      it 'children are stopped' do
        children.each { |child| expect(child.stopped?).to eq(true) }
      end
    end
  end
end
