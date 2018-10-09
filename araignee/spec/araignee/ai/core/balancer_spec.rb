require 'araignee/ai/core/balancer'
require 'araignee/ai/core/filters/filter_running'
require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker_random'

RSpec.describe Ai::Core::Balancer do
  let(:world) { {} }
  let(:entity) { {} }

  let(:picker) { nil }
  let(:picker_random) { Ai::Core::Pickers::PickerRandom.new }
  let(:filter) { Ai::Core::Filters::FilterRunning.new }

  let(:children) { (1..3).map { Ai::Core::Node.new } }
  let(:balancer) { Ai::Core::Balancer.new(children: children, picker: picker, filters: [filter]) }

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

    context 'valid picker' do
      let(:picker) { picker_random }

      it 'sets picker' do
        expect(balancer.picker).to eq(picker)
      end
    end
  end

  describe '#process' do
    let(:picker) { picker_random }

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
