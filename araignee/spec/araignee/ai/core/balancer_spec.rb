require 'araignee/ai/core/balancer'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Balancer do
  include Araignee::Ai::Helpers

  let(:picked) { nil }
  let(:picker) { double('[picker]', pick: [picked]) }
  let(:filters) { [] }

  let(:child_succeeded) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:child_failed) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:child_busy) { Araignee::Ai::Helpers::NodeBusy.new }
  let(:children) { [1, 2, 3] }

  let(:children) { [child_succeeded, child_failed, child_busy] }
  let(:balancer) { described_class.new(children: children, picker: picker, filters: filters) }

  before do
    child_succeeded.state = initial_state
    child_failed.state = initial_state
    child_busy.state = initial_state
    balancer.state = initial_state
  end

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
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

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
