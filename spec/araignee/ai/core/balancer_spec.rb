require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_balancer_fabricator'
require 'araignee/ai/core/pickers/picker_random'

RSpec.describe Ai::Core::Balancer do
  let(:world) { {} }
  let(:entity) { {} }

  let(:picker) { nil }
  let(:filter) { Ai::Core::Filters::FilterRunning.new }

  let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_busy)] }
  let(:balancer) { Fabricate(:ai_balancer, children: children, picker: picker, filters: [filter]) }

  describe '#initialize' do
    it 'sets children' do
      expect(balancer.children).to eq(children)
    end

    it 'sets picker' do
      expect(balancer.picker).to eq(picker)
    end

    context 'valid picker' do
      let(:picker) { Ai::Core::Pickers::PickerRandom.new }

      it 'sets picker' do
        expect(balancer.picker).to eq(picker)
      end
    end
  end

  describe '#process' do
    let(:picker) { Ai::Core::Pickers::PickerRandom.new }

    subject { balancer.process(entity, world) }

    before { balancer.start! }

    context 'without picker' do
      let(:picker) { nil }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'with picker' do
      context 'when no node was picked' do
        before { allow(picker).to receive(:pick_one).with(children) { nil } }

        it 'has failed' do
          expect(subject.failed?).to eq(true)
        end
      end

      context 'when picker picks one child' do
        before { allow(picker).to receive(:pick_one).with(children) { children.first } }

        it 'picker#pick_one is called' do
          expect(picker).to receive(:pick_one).with(children)
          subject
        end

        it 'has succeeded' do
          expect(subject.succeeded?).to eq(true)
        end

        context 'executed child node state is failed' do
          before { allow(picker).to receive(:pick_one).with(children) { children[1] } }

          it 'has failed' do
            expect(subject.failed?).to eq(true)
          end
        end

        context 'executed child node state is busy' do
          before { allow(picker).to receive(:pick_one).with(children) { children[2] } }

          it 'is busy' do
            expect(subject.busy?).to eq(true)
          end
        end
      end
    end
  end
end
