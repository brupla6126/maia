require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Actions::ActionSucceeded do
  let(:world) { double('[world]') }
  let(:entity) { {} }

  before { allow(world).to receive(:delta) { 1 } }

  let(:action) { ActionSucceeded.new({}) }

  describe '#process' do
    subject { action.process(entity, world) }

    before { action.start! }

    context 'before process' do
      it 'should NOT be busy' do
        expect(action.busy?).to eq(false)
      end
    end

    context 'after process' do
      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    it 'node @elapsed should be updated' do
      expect(subject.elapsed).to eq(1)
    end

    it 'returns self' do
      expect(subject).to eq(action)
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
