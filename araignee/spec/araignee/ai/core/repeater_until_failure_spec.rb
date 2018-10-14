require 'araignee/ai/core/node'
require 'araignee/ai/core/repeater_until_failure'

RSpec.describe Ai::Core::RepeaterUntilFailure do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Ai::Core::NodeFailed.new }
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
