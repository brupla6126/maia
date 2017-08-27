require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Actions::ActionSucceeded do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action) { ActionSucceeded.new }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { action.start! }
    subject { action.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end

RSpec.describe AI::Actions::ActionTemporarySucceeded do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    let(:times) { 0 }
    let(:action) { ActionTemporarySucceeded.new(times: times) }

    before { action.start! }
    subject { action.process(entity, world) }

    it 'should have failed' do
      expect(subject.failed?).to eq(true)
    end

    context 'succeed twice' do
      let(:times) { 2 }

      it 'should succeed twice and then fail' do
        1.upto(times + 1) do |i|
          action.process(entity, world)

          if i <= times
            expect(action.succeeded?).to eq(true)
          else
            expect(action.failed?).to eq(true)
          end
        end
      end
    end
  end
end
