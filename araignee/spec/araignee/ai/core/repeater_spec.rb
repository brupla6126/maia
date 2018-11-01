require 'araignee/ai/core/repeater'

RSpec.describe Araignee::Ai::Core::Repeater do
  let(:child) { Araignee::Ai::Core::NodeFailed.new }
  let(:repeater) { described_class.new(child: child) }

  before do
    child.state = initial_state
    repeater.state = initial_state
  end

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(repeater.child).to eq(child)
    end
  end

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { repeater.process(entity, world) }

    context 'calling repeater#repeat' do
      it 'repeater#repeat is called' do
        expect(repeater).to receive(:repeat).with(child, entity, world)
        subject
      end
    end

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
