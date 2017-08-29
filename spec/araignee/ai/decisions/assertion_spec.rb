require 'araignee/ai/decisions/assertion'

RSpec.describe AI::Decisions::Assertion do
  class AssertionDerived < AI::Decisions::Assertion
    def assert(_entity, _world)
      :succeeded
    end
  end

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { assertion.start! }

    subject { assertion.process(entity, world) }

    context 'when not derived' do
      let(:assertion) { AI::Decisions::Assertion.new }

      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      let(:assertion) { AssertionDerived.new }

      context 'when assertion test resolves to :succeeded' do
        before { subject }

        it 'should have succeeded' do
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when assertion test does not resolve to :succeeded or :failed' do
        before { allow_any_instance_of(AssertionDerived).to receive(:assert).and_return(:running) }
        before { subject }

        it 'should fail' do
          expect(subject.failed?).to eq(true)
        end
      end
    end
  end
end
