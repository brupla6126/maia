require 'araignee/ai/actions/canceled'

include AI::Actions

RSpec.describe AI::Actions::ActionCanceled do
  let(:action) { ActionCanceled.new }

  describe '#start' do
    before { action.fire_state_event(:start) }
    subject { action }

    it 'should have been canceled' do
      expect(subject.canceled?).to eq(true)
    end
  end
end
