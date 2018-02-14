require 'araignee/architecture/client'

RSpec.describe Architecture::Client do
  subject { client }

  let(:client) { described_class.new(states) }

  describe '#initialize' do
    let(:states) { StateStack.new }

    it 'has states' do
      expect(client.states).to eq(states)
    end
  end
end
