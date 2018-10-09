require 'araignee/ai/core/decorator'
require 'araignee/ai/core/node'

RSpec.describe Ai::Core::Decorator do
  let(:start_child) { true }
  let(:stop_child) { true }
  let(:decorating) { Ai::Core::Node.new }
  let(:decorator) { described_class.new(child: decorating, start_child: start_child, stop_child: stop_child) }

  subject { decorator }

  before { Log[:ai] = double('Log[:ai]') }
  before { allow(Log[:ai]).to receive(:debug) }
  after { Log[:ai] = Log[:default] }

  describe '#initialize' do
    it 'decorator is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'child is ready' do
      expect(subject.child.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.child.response).to eq(:unknown)
    end
  end

  describe '#node_starting' do
    subject { super().start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }

      subject
    end

    context 'with decorating node' do
      context 'attribute start_child set to false' do
        let(:start_child) { false }

        context 'child starting' do
          before { allow(decorator.child).to receive(:start!) }

          it 'does not call child#stop!' do
            expect(decorator.child).not_to receive(:start!)
            subject
          end
        end

        it 'decorating node is still ready' do
          expect(decorator.ready?).to eq(true)
        end
      end

      context 'attribute start_child set to true' do
        context 'child starting' do
          before { allow(decorator.child).to receive(:start!) }

          it 'does call child#stop!' do
            expect(decorator.child).to receive(:start!)
            subject
          end
        end

        it 'decorating node is running' do
          subject
          expect(decorator.child.running?).to eq(true)
        end
      end

      context 'validate_attributes' do
        before { allow(decorator.child).to receive(:validate_attributes) }

        it 'validates attributes' do
          expect(decorator.child).to receive(:validate_attributes)
          subject
        end
      end

      it 'decorator is running' do
        subject
        expect(decorator.running?).to eq(true)
      end
    end

    context 'without decorating node' do
      let(:decorating) { nil }

      it 'raises ArgumentError' do
        expect { subject.start! }.to raise_error(ArgumentError, 'invalid decorating child')
      end
    end
  end

  describe '#node_stopping' do
    subject { super().stop! }

    before { decorator.start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.inspect}") }

      subject
    end

    context 'child node set' do
      context 'attribute stop_child set to false' do
        let(:stop_child) { false }

        context 'child stopping' do
          before { allow(decorator.child).to receive(:stop!) }

          it 'does not call child#stop!' do
            expect(decorator.child).not_to receive(:stop!)
            subject
          end
        end

        it 'decorating node is still running' do
          expect(decorator.running?).to eq(true)
        end
      end

      context 'attribute stop_child set to true' do
        context 'child stopping' do
          before { allow(decorator.child).to receive(:stop!) }

          it 'does call child#stop!' do
            expect(decorator.child).to receive(:stop!)
            subject
          end
        end

        it 'decorating node is stopped' do
          subject
          expect(decorator.child.stopped?).to eq(true)
        end
      end

      it 'decorator is stopped' do
        subject
        expect(decorator.stopped?).to eq(true)
      end
    end
  end
end
