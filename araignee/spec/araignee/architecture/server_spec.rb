require 'araignee/architecture/server'

RSpec.describe Architecture::Server do
  subject { server }

  let(:server) { described_class.new(states) }

  let(:states) { StateStack.new }

  describe '#initialize' do
    it 'has states' do
      expect(subject.states).to eq(states)
    end
  end
end
