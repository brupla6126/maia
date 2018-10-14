require 'araignee/architecture/server'

RSpec.describe Araignee::Architecture::Server do
  subject { server }

  let(:server) { described_class.new(states) }

  let(:states) { Araignee::Utils::StateStack.new }

  describe '#initialize' do
    it 'has states' do
      expect(subject.states).to eq(states)
    end
  end
end
