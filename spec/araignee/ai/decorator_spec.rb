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

  describe '#start' do
    context 'child node nil' do
      let(:decorating) { nil }

      it 'raise ArgumentError' do
        expect { decorator.fire_state_event(:start) }.to raise_error(ArgumentError)
      end
    end

    context 'child node set' do
      before { decorator.fire_state_event(:start) }

      it 'decorator should be running' do
        expect(decorator.running?).to eq(true)
      end

      it 'decorating node should be running' do
        expect(decorator.node.running?).to eq(true)
      end
    end
  end
end
