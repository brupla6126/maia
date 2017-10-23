require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_repeater_fabricator'

RSpec.describe Ai::Core::RepeaterUntilSuccess do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Fabricate(:ai_node_succeeded) }
  let(:repeater) { Fabricate(:ai_repeater_until_success, child: child) }

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    subject { repeater.process(entity, world) }

    before { repeater.start! }

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
