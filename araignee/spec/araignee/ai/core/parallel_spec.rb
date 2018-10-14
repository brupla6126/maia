require 'araignee/ai/core/parallel'

RSpec.describe Araignee::Ai::Core::Parallel do
  let(:world) { {} }
  let(:entity) { {} }

  let(:completions) { 0 }
  let(:failures) { 0 }
  let(:filter) { Araignee::Ai::Core::Filters::FilterRunning.new }
  let(:children) { [] }
  let(:parallel) { described_class.new(children: children, completions: completions, failures: failures, filters: []) }

  subject { parallel }

  describe '#initialize' do
    context 'when attributes :completions and failures are not set' do
      it 'completions and failures should default to 0' do
        parallel = described_class.new

        expect(parallel.children).to eq([])
        expect(parallel.completions).to eq(completions)
        expect(parallel.failures).to eq(failures)
      end
    end
  end

  describe '#process' do
    subject { parallel.process(entity, world) }

    context 'when actions :succeeded, :failed, :failed and :completions, :failures are not set' do
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'stays busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :completions = 1' do
      let(:completions) { 1 }
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :completions = 2' do
      let(:completions) { 2 }
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'stays busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :failures = Integer::MAX' do
      let(:completions) { 0 }
      let(:failures) { Integer::MAX }

      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'stays busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed and :completions = Integer::MAX' do
      let(:completions) { Integer::MAX }
      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'stays busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :succeeded and :failures = 1' do
      let(:failures) { 1 }

      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when actions :succeeded, :failed, :failed and :failures = 2' do
      let(:failures) { 2 }

      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :succeeded, :failed, :failed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'should stay busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when :failed, :failed, :failed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :succeeded, :failed, :failed, :failed and :completions = 3, :failures = 2' do
      let(:completions) { 3 }
      let(:failures) { 2 }

      let(:children) { [Araignee::Ai::Core::NodeSucceeded.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when :failed, :failed, :failed and :completions = 3' do
      let(:completions) { 3 }
      let(:failures) { Integer::MAX }

      let(:children) { [Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new, Araignee::Ai::Core::NodeFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end

  describe 'validates attributes' do
    subject { super().send(:validate_attributes) }

    context 'when completions is invalid' do
      let(:completions) { -2 }

      it 'raises ArgumentError, completions must be >= 0' do
        expect { subject }.to raise_error(ArgumentError, 'completions must be >= 0')
      end
    end

    context 'when completions is valid' do
      let(:completions) { 3 }

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

    context 'when completions and failures are equal' do
      let(:completions) { 1 }
      let(:failures) { 1 }

      it 'should raise ArgumentError, completions and failures must not equal' do
        expect { subject }.to raise_error(ArgumentError, 'completions and failures must not equal')
      end
    end
  end
end
