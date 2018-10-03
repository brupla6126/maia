require 'araignee/ai/core/wait'
require 'araignee/ai/core/repeater_number_times'

RSpec.describe Ai::Core::RepeaterNumberTimes do
  let(:world) { {} }
  let(:entity) { {} }

  let(:times) { 5 }
  let(:child) { Ai::Core::Wait.new(delay: 200) }
  let(:repeater) { described_class.new(child: child, times: times) }

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { repeater.start! }

    context 'number of times negative' do
      let(:times) { -2 }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'times must be > 0')
      end
    end

    context 'number of times > 0' do
      before { allow(repeater.child).to receive(:process) }

      it 'does call child#process specified number of times' do
        expect(repeater.child).to receive(:process).exactly(times).times
        subject
      end
    end

    it 'returns :succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
