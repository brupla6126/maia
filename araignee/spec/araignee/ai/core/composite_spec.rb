require 'araignee/ai/core/composite'

RSpec.describe Araignee::Ai::Core::Composite do
  class MyComposite < described_class
    def execute(entity, world)
      response = nil

      nodes.each do |node|
        response = node.process(entity, world).response
      end

      response ||= :failed

      # send last child's response
      update_response(response)
    end
  end

  let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeBusy.new] }
  let(:filters) { [] }
  let(:picked) { nil }
  let(:picker) { nil }
  let(:sorter) { nil }
  let(:sort_reversed) { false }
  let(:composite_params) do
    {
      children: children,
      filters: filters,
      picker: picker,
      sorter: sorter,
      sort_reversed: sort_reversed
    }
  end

  let(:composite) { MyComposite.new(composite_params) }

  subject { composite }

  describe '#initialize' do
    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end

    it 'children are set' do
      expect(subject.children).to eq(children)
    end

    it 'children response are :unknown' do
      children.each { |child| expect(child.response).to eq(:unknown) }
    end

    it 'picker is nil' do
      expect(subject.picker).to eq(picker)
    end

    context 'with picker' do
      let(:picker) { Araignee::Ai::Core::Pickers::Picker.new }

      it 'picker is set' do
        expect(subject.picker).to eq(picker)
      end
    end

    context 'with sorter' do
      let(:sorter) { Araignee::Ai::Core::Sorters::Sorter.new }

      it 'sorter is set' do
        expect(subject.sorter).to eq(sorter)
      end
    end
  end

  describe '#child' do
    let(:child1) { Araignee::Ai::Core::Node.new }
    let(:child2) { Araignee::Ai::Core::Node.new }
    let(:child3) { Araignee::Ai::Core::Node.new(identifier: child1.identifier) }
    let(:children) { [child1, child2, child3] }

    let(:child_identifier) { child1.identifier }

    subject { super().child(child_identifier) }

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

    let(:added_child) { Araignee::Ai::Core::Node.new }
    let(:index) { :last }

    it 'should have all children' do
      expect(subject.children.count).to eq(4)
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
          expect(subject.children.count).to eq(4)
        end
      end

      context 'when insert at specified position' do
        let(:index) { 1 }

        it 'inserts at specified position' do
          expect(subject.children[index]).to eq(added_child)
          expect(subject.children.count).to eq(4)
        end
      end
    end
  end

  describe '#remove_child' do
    subject { super().remove_child(removed_child) }

    context 'known child' do
      let(:child) { Araignee::Ai::Core::Node.new }
      let(:children) { [child] }

      let(:removed_child) { child }

      it 'removes child' do
        expect(subject.children.include?(child)).to eq(false)
      end
    end

    context 'unknown child' do
      let(:child) { Araignee::Ai::Core::Node.new }
      let(:unknown) { Araignee::Ai::Core::Node.new }
      let(:children) { [child] }

      let(:removed_child) { unknown }

      it 'does not remove' do
        expect(subject.children.count).to eq(1)
      end
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'with picker' do
      let(:picker) { double('[picker]', pick: [picked]) }

      context 'when picker picks one child' do
        let(:picked) { children.first }

        it 'picker#pick_one is called' do
          expect(subject.succeeded?).to eq(true)
        end

        context 'executed child node state is failed' do
          let(:picked) { children[1] }

          it 'has failed' do
            expect(subject.failed?).to eq(true)
          end
        end

        context 'executed child node state is busy' do
          let(:picked) { children[2] }

          it 'is busy' do
            expect(subject.busy?).to eq(true)
          end
        end
      end
    end

    context 'without sorter' do
      it 'returns passed nodes' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'with sorter' do
      let(:sorter) { Araignee::Ai::Core::Sorters::Sorter.new }

      context 'empty nodes passed' do
        let(:picker) { double('[picker]', pick: [picked]) }

        before { allow(picker).to receive(:pick).with(children) { [] } }

        it 'does not call sorter#sort' do
          expect(subject.failed?).to eq(true)
        end
      end

      context 'valid nodes passed' do
        let(:sort_reversed) { true }

        it 'does call sorter#sort' do
          expect(subject.succeeded?).to eq(true)
        end
      end
    end
  end

  describe 'reset' do
    subject { super().reset }

    after { subject }

    context 'returned value' do
      it 'returns self' do
        expect(subject).to eq(composite)
      end
    end

    it 'reset response attribute' do
      expect(composite).to receive(:reset_attribute).with(:response)
    end

    context 'children' do
      let(:child) { double('[child]') }
      let(:children) { [child] }

      before { allow(child).to receive(:validate_attributes) }
      before { allow(child).to receive(:reset) }

      it 'calls reset on each child' do
        expect(child).to receive(:reset)
      end
    end

    context 'sorter' do
      let(:sorter) { double('[sorter]') }

      before { allow(sorter).to receive(:reset) }

      it 'calls sorter#reset' do
        expect(sorter).to receive(:reset)
      end
    end
  end
end
