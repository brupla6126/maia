require 'araignee/ai/core/node'
require 'araignee/ai/core/repeater_until_success'

RSpec.describe Araignee::Ai::Core::RepeaterUntilSuccess do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:repeater) { described_class.new(child: child) }

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    subject { repeater.process(entity, world) }

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
