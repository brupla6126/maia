require 'araignee/ai/core/balancer'

RSpec.describe Araignee::Ai::Core::Balancer do
  let(:world) { {} }
  let(:entity) { {} }

  let(:picked) { nil }
  let(:picker) { double('[picker]', pick_one: picked) }
  let(:filters) { [] }

  let(:children) { (1..3).map { Araignee::Ai::Core::Node.new } }
  let(:balancer) { Araignee::Ai::Core::Balancer.new(children: children, picker: picker, filters: filters) }

  subject { balancer }

  before do
    allow(children[0]).to receive(:response) { :succeeded }
    allow(children[1]).to receive(:response) { :failed }
    allow(children[2]).to receive(:response) { :busy }
  end

  describe '#initialize' do
    it 'sets children' do
      expect(balancer.children).to eq(children)
    end

    it 'sets picker' do
      expect(balancer.picker).to eq(picker)
    end
  end

  describe '#process' do
    subject { balancer.process(entity, world) }

    context 'without picker' do
      let(:picker) { nil }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'with picker' do
      context 'when no node was picked' do
        it 'has failed' do
          expect(subject.failed?).to eq(true)
        end
      end

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
end
