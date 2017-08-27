require 'araignee/ai/decorator'

RSpec.describe AI::Decorator do
  let(:decorating) { AI::Node.new }
  let(:decorator) { AI::Decorator.new(node: decorating) }

  describe '#initialize' do
    context 'when initializing' do
      it 'child node should be set' do
        expect(decorator.node).to eq(decorating)
      end
    end
  end

  describe '#start!' do
    context 'child node nil' do
      let(:decorating) { nil }

      it 'raise ArgumentError' do
        expect { decorator.start! }.to raise_error(ArgumentError)
      end
    end

    context 'child node set' do
      before { decorator.start! }

      it 'decorator should be started' do
        expect(decorator.started?).to eq(true)
      end

      it 'decorating node should be started' do
        expect(decorator.node.started?).to eq(true)
      end
    end
  end

  describe '#stop!' do
    context 'child node set' do
      before { decorator.start! }
      before { decorator.stop! }

      it 'decorator should be stopped' do
        expect(decorator.stopped?).to eq(true)
      end

      it 'child node should be stopped' do
        expect(decorating.stopped?).to eq(true)
      end
    end
  end
end
