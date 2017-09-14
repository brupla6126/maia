require 'araignee/ai/decisions/assertion'

RSpec.describe AI::Decisions::Assertion do
  class AssertionDerived < AI::Decisions::Assertion
    def assert(_entity, _world)
      :succeeded
    end
  end

  let(:world) { double('[world]') }
  let(:entity) { {} }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    subject { assertion.process(entity, world) }

    let(:assertion) { AI::Decisions::Assertion.new({}) }

    context 'when not derived' do
      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      before { assertion.start! }

      let(:assertion) { AssertionDerived.new({}) }

      it 'node @elapsed should be updated' do
        expect(subject.elapsed).to eq(1)
      end

      context 'when assertion test resolves to :succeeded' do
        before { allow(assertion).to receive(:assert).with(entity, world) { :succeeded } }

        it 'should have succeeded' do
          expect(assertion).to receive(:assert).with(entity, world)
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when assertion test does not resolve to :succeeded or :failed' do
        before { allow_any_instance_of(AssertionDerived).to receive(:assert) { :running } }

        it 'should fail' do
          expect(subject.failed?).to eq(true)
        end
      end
    end
  end
end
