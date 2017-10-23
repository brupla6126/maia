require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_repeater_fabricator'

RSpec.describe Ai::Core::RepeaterNumberTimes do
  let(:world) { {} }
  let(:entity) { {} }

  let(:times) { 5 }
  let(:child) { Fabricate(:ai_node_failed) }
  let(:repeater) { Fabricate(:ai_repeater_number_times, child: child, times: times) }

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    subject { repeater.process(entity, world) }

    before { repeater.start! }

    context 'number of times negative' do
      let(:times) { -2 }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'times must be > 0')
      end
    end

    context 'number of times > 0' do
      context 'child#process' do
        before { allow(repeater.child).to receive(:process) }

        it 'does call child#process specified number of times' do
          expect(repeater.child).not_to receive(:process).exactly(times).times
          subject
        end
      end
    end

    it 'returns :succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
