require 'araignee/ai/assertion'

RSpec.describe AI::Assertion do
  class AssertionDerived < AI::Assertion
    def assert(_entity, _world)
      :succeeded
    end
  end

  let(:world) { {} }
  let(:entity) { {} }
  let(:assertion) { AI::Assertion.new }

  describe '#process' do
    subject { assertion.process(entity, world) }

    context 'when not derived' do
      it 'should raise NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

    context 'when derived' do
      before { assertion.start! }

      let(:assertion) { AssertionDerived.new }

      context 'when assertion test resolves to :succeeded' do
        before { allow(assertion).to receive(:assert) { :succeeded } }

        it 'has succeeded' do
          expect(assertion).to receive(:assert).with(entity, world)
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when assertion test does not resolve to :succeeded' do
        before { allow(assertion).to receive(:assert) { :running } }

        it 'has failed' do
          expect(subject.failed?).to eq(true)
        end
      end
    end
  end
end
