require 'araignee/ai/fabricators/ai_node_fabricator'
require 'araignee/ai/fabricators/ai_decorator_fabricator'

RSpec.describe AI::Decorator do
  let(:decorating) { Fabricate(:ai_node) }
  let(:decorator) { Fabricate(:ai_decorator, child: decorating) }

  before { Log[:ai] = double('Log[:ai]') }
  before { allow(Log[:ai]).to receive(:debug) }
  after { Log[:ai] = Log[:default] }

  subject { decorator }

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

  describe '#child=' do
    let(:new_child) { Fabricate(:ai_node) }

    context 'without decorating child' do
      it 'raises ArgumentError new decorating node must be AI::Node' do
        expect { subject.child = nil }.to raise_error(ArgumentError, 'invalid decorating child')
      end
    end

    context 'with decorating child' do
      context 'decorator is running' do
        before { subject.start! }

        context 'decorating child running' do
          before { allow(decorating).to receive(:can_stop?).and_return(true) }
          before { subject.child = new_child }

          it 'decorating child is stopped' do
            expect(decorating).to have_received(:can_stop?)
            expect(decorating.stopped?).to eq(true)
          end

          it 'new decorating child is set' do
            expect(subject.child).to eq(new_child)
          end

          it 'new decorating child is running' do
            expect(new_child.running?).to eq(true)
          end
        end

        context 'decorating child is paused' do
          before { decorating.pause! }
          before { subject.child = new_child }

          it 'decorating child is stopped' do
            expect(decorating.stopped?).to eq(true)
          end

          it 'new decorating child is set' do
            expect(subject.child).to eq(new_child)
          end

          it 'new decorating node is running' do
            expect(new_child.running?).to eq(true)
          end
        end
      end

      context 'decorator is not running' do
        before { subject.child = new_child }

        it 'decorating child is not running' do
          expect(decorating.running?).to eq(false)
        end

        context 'changing decorating child' do
          it 'decorating child is stopped' do
            expect(decorating.stopped?).to eq(false)
          end

          it 'new decorating child is set' do
            expect(subject.child).to eq(new_child)
          end

          it 'new decorating child is not running' do
            expect(subject.child.running?).to eq(false)
          end
        end
      end
    end
  end

  describe '#node_starting' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }

      subject.start!
    end

    context 'with decorating node' do
      before { allow(subject.child).to receive(:validate_attributes) }
      before { subject.start! }

      it 'decorator is running' do
        expect(subject.running?).to eq(true)
      end

      it 'validates attributes' do
        expect(subject.child).to have_received(:validate_attributes)
      end
    end

    context 'without decorating node' do
      let(:decorator) { Fabricate(:ai_decorator, child: nil) }

      it 'raises ArgumentError' do
        expect { subject.start! }.to raise_error(ArgumentError, 'invalid decorating child')
      end
    end
  end

  describe '#node_stopping' do
    before { subject.start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.child.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.inspect}") }

      subject.stop!
    end

    context 'child node set' do
      before { subject.stop! }

      it 'decorator is stopped' do
        expect(subject.stopped?).to eq(true)
      end

      it 'decorating node is stopped' do
        expect(subject.child.stopped?).to eq(true)
      end
    end
  end
end
