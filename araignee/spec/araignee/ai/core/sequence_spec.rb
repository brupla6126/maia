require 'araignee/ai/core/sequence'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Sequence do
  include Araignee::Ai::Helpers

  let(:child_succeeded) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:child_failed) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:child_busy) { Araignee::Ai::Helpers::NodeBusy.new }
  let(:children) { [1, 2, 3] }
  let(:sequence) { described_class.new(children: children, filters: []) }

  before do
    child_succeeded.state = initial_state
    child_failed.state = initial_state
    child_busy.state = initial_state
    sequence.state = initial_state
  end

  subject { sequence }

  describe '#initialize' do
    it 'sets children' do
      expect(subject.children).to eq(children)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    context 'when children = [:succeeded, :succeeded]' do
      let(:children) { [child_succeeded, child_succeeded] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when children = [:succeeded, :busy, :succeeded]' do
      let(:children) { [child_succeeded, child_busy, child_succeeded] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when children = [:succeeded, :failed]' do
      let(:children) { [child_succeeded, child_failed] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
