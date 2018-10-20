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
  let(:composite_attributes) do
    {
      children: children,
      filters: filters,
      picker: picker,
      sorter: sorter,
      sort_reversed: sort_reversed
    }
  end

  let(:composite) { MyComposite.new(composite_attributes) }

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
