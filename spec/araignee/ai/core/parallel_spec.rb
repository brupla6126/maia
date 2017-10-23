require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_parallel_fabricator'
require 'araignee/ai/core/filters/filter_running'

RSpec.describe Ai::Core::Parallel do
  let(:world) { {} }
  let(:entity) { {} }

  let(:completion) { 0 }
  let(:failures) { 0 }
  let(:filter) { Ai::Core::Filters::FilterRunning.new }
  let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed)] }
  let(:parallel) { Fabricate(:ai_parallel, children: children, completion: completion, failures: failures, filters: []) }

  subject { parallel }

  describe '#initialize' do
    context 'when attributes :completion and failures are not set' do
      it ':completion and failures should default to 0' do
        parallel = Fabricate(:ai_parallel, children: children)

        expect(parallel.completion).to eq(0)
        expect(parallel.failures).to eq(0)
      end
    end
  end

  describe '#node_starting' do
    subject { super().start! }

    context 'validates attributes' do
    end
  end

  describe '#process' do
    subject { parallel.process(entity, world) }

    before { parallel.start! }

    context 'when actions :succeeded, :failed, :failed, :stopped and :completion, :failures are not set' do
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed), Fabricate(:ai_node_stopped)] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :completion = 1' do
      let(:completion) { 1 }
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :completion = 2' do
      let(:completion) { 2 }
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :failures = Integer::MAX' do
      let(:completion) { 0 }
      let(:failures) { Integer::MAX }

      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed and :completion = Integer::MAX' do
      let(:completion) { Integer::MAX }
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed)] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :succeeded and :failures = 1' do
      let(:failures) { 1 }

      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_succeeded)] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :failures = 2' do
      let(:failures) { 2 }

      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :succeeded, :failed, :failed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when :failed, :failed, :failed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:children) { [Fabricate(:ai_node_failed), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :succeeded, :failed, :failed, :failed and :completion = 3, :failures = 2' do
      let(:completion) { 3 }
      let(:failures) { 2 }

      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :failed, :failed, :failed and :completion = 3' do
      let(:completion) { 3 }
      let(:failures) { Integer::MAX }

      let(:children) { [Fabricate(:ai_node_failed), Fabricate(:ai_node_failed), Fabricate(:ai_node_failed)] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end

  describe 'validates attributes' do
    subject { super().send(:validate_attributes) }

    context 'when completion is invalid' do
      let(:completion) { -2 }

      it 'raises ArgumentError, completion must be >= 0' do
        expect { subject }.to raise_error(ArgumentError, 'completion must be >= 0')
      end
    end

    context 'when completion is valid' do
      let(:completion) { 3 }

      it 'does not raise' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when failures is invalid' do
      let(:failures) { -2 }

      it 'raises ArgumentError, failures must be >= 0' do
        expect { subject }.to raise_error(ArgumentError, 'failures must be >= 0')
      end
    end

    context 'when failures is valid' do
      let(:failures) { 3 }

      it 'does not raise' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when completion and failures are equal' do
      let(:completion) { 1 }
      let(:failures) { 1 }

      it 'should raise ArgumentError, completion and failures must not equal' do
        expect { subject }.to raise_error(ArgumentError, 'completion and failures must not equal')
      end
    end
  end
end
