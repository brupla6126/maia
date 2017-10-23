require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_repeater_fabricator'

RSpec.describe Ai::Core::Repeater do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Fabricate(:ai_node) }
  let(:repeater) { Fabricate(:ai_repeater, child: child) }

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(repeater.child).to eq(child)
    end
  end

  describe '#process' do
    subject { repeater.process(entity, world) }

    before { repeater.start! }

    context 'calling repeater#repeat' do
      before { allow(repeater).to receive(:repeat).with(child, entity, world) { nil } }

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
