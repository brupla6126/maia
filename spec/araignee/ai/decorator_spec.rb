require 'araignee/ai/actions/succeeded'
require 'araignee/ai/decorator'

RSpec.describe AI::Decorator do
  let(:decorating) { AI::Node.new({}) }
  let(:attributes) { { node: decorating } }
  let(:decorator) { AI::Decorator.new(attributes) }

  before { Log[:ai] = double('Log[:ai] start!') }
  before { allow(Log[:ai]).to receive(:debug) }
  before { allow(Log[:ai]).to receive(:warn) }
  after { Log[:ai] = Log[:default] }

  subject { decorator }

  describe '#initialize' do
    context 'attributes nil' do
      let(:attributes) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'attributes must be Hash')
      end
    end

    context 'attributes of invalid type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'attributes must be Hash')
      end
    end

    context 'with attributes empty' do
      let(:attributes) { {} }

      it 'decorating node should be set' do
        expect { subject }.to raise_error(ArgumentError, 'invalid decorating node')
      end
    end

    context 'invalid identifier' do
      let(:identifier) { AI::Node.new({}) }

      before { attributes[:identifier] = identifier }

      it 'raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "invalid identifier: #{identifier}")
      end
    end

    context 'with attributes' do
      it 'decorator should be ready' do
        expect(subject.ready?).to eq(true)
      end

      it 'decorating node should be ready' do
        expect(subject.node.ready?).to eq(true)
      end
    end
  end

  describe '#node=' do
    let(:new_node) { AI::Node.new({}) }

    context 'without decorating node' do
      it 'should raise ArgumentError new decorating node must be AI::Node' do
        expect { subject.node = nil }.to raise_error(ArgumentError, 'invalid decorating node')
      end
    end

    context 'with decorating node' do
      context 'decorator is running' do
        before { subject.start! }

        context 'decorating node running' do
          before { allow(decorating).to receive(:can_stop?).and_return(true) }
          before { subject.node = new_node }

          it 'decorating node should be stopped' do
            expect(decorating).to have_received(:can_stop?)
            expect(decorating.stopped?).to eq(true)
          end

          it 'new decorating node should be set' do
            expect(subject.node).to eq(new_node)
          end

          it 'new decorating node should be running' do
            expect(new_node.running?).to eq(true)
          end
        end

        context 'decorating node paused' do
          before { decorating.pause! }
          before { subject.node = new_node }

          it 'decorating node should be stopped' do
            expect(decorating.stopped?).to eq(true)
          end

          it 'new decorating node should be set' do
            expect(subject.node).to eq(new_node)
          end

          it 'new decorating node should be running' do
            expect(new_node.running?).to eq(true)
          end
        end
      end

      context 'decorator is not running' do
        before { subject.node = new_node }

        it 'decorating node should not be running' do
          expect(decorating.running?).to eq(false)
        end

        context 'changing decorating node' do
          it 'decorating node should not be stopped' do
            expect(decorating.stopped?).to eq(false)
          end

          it 'new decorating node should be set' do
            expect(subject.node).to eq(new_node)
          end

          it 'new decorating node should not be running' do
            expect(subject.node.running?).to eq(false)
          end
        end
      end
    end
  end

  describe '#node_starting' do
    context 'with decorating node' do
      before { subject.start! }

      it 'decorator should be running' do
        expect(subject.running?).to eq(true)
      end

      it 'decorating node should be running and call Log[:ai].debug' do
        expect(subject.node.running?).to eq(true)
        expect(Log[:ai]).to have_received(:debug).exactly(4).times
      end
    end
  end

  describe '#node_stopping' do
    context 'child node set' do
      before { subject.start! }
      before { subject.stop! }

      it 'decorator should be stopped and call Log[:ai].debug' do
        expect(subject.stopped?).to eq(true)
        expect(Log[:ai]).to have_received(:debug).exactly(8).times
      end

      it 'decorating node should be stopped' do
        expect(subject.node.stopped?).to eq(true)
      end
    end
  end
end
