require 'araignee/ai/core/node'
require 'araignee/ai/core/repeater_until_failure'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::RepeaterUntilFailure do
  include Araignee::Ai::Helpers

  let(:child) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:repeater) { described_class.new(child: child) }

  before do
    child.state = initial_state
    repeater.state = initial_state
  end

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
