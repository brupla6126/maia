require 'araignee/ai/core/balancer'

RSpec.describe Araignee::Ai::Core::Balancer do
  let(:picked) { nil }
  let(:picker) { double('[picker]', pick: [picked]) }
  let(:filters) { [] }

  let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeBusy.new] }
  let(:balancer) { described_class.new(children: children, picker: picker, filters: filters) }

  subject { balancer }

  describe '#initialize' do
    it 'sets children' do
      expect(subject.children).to eq(children)
    end

    it 'sets picker' do
      expect(subject.picker).to eq(picker)
    end

    it 'sets filters' do
      expect(subject.filters).to eq(filters)
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

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
end
