require 'araignee/architecture/client'
require 'araignee/utils/state_stack'

RSpec.describe Araignee::Architecture::Client do
  subject { client }

  let(:client) { described_class.new(states) }

  describe '#initialize' do
    let(:states) { Araignee::Utils::StateStack.new }

    it 'has states' do
      expect(client.states).to eq(states)
    end
  end
end
