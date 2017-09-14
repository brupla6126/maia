require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/condition'

include AI::Actions

RSpec.describe AI::Behaviors::Condition do
  let(:world) { double('[world]') }
  let(:entity) { {} }

  before { allow(world).to receive(:delta) { 1 } }

  let(:action_busy) { ActionBusy.new({}) }
  let(:action_failed) { ActionFailed.new({}) }
  let(:action_succeeded) { ActionSucceeded.new({}) }

  let(:term_failed) { ActionFailed.new({}) }
  let(:term_succeeded) { ActionSucceeded.new({}) }

  let(:term) { term_failed }
  let(:yes) { action_succeeded }
  let(:no) { action_busy }
  let(:nodes) { [term, yes, no] }

  let(:attributes) { { nodes: nodes } }

  let(:condition) { AI::Behaviors::Condition.new(attributes) }

  describe '#initialize' do
    subject { condition }

    context 'attributes nil' do
      let(:attributes) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'attributes must be Hash')
      end
    end

    context 'attributes of invalid type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'attributes must be Hash')
      end
    end

    context 'attributes empty' do
      let(:attributes) { {} }

      it 'should not raise error' do
        expect { subject }.to raise_error(ArgumentError, 'nodes must be Array')
      end
    end

    context 'node[0] not set' do
      let(:nodes) { [nil, yes, no] }

      it 'should not raise error' do
        expect { subject }.to raise_error(ArgumentError, 'term node must be set in nodes[0]')
      end
    end

    context 'node[1] not set' do
      let(:nodes) { [term, nil, no] }

      it 'should not raise error' do
        expect { subject }.to raise_error(ArgumentError, 'yes node must be set in nodes[1]')
      end
    end

    context 'node[2] not set' do
      let(:nodes) { [term, yes, nil] }

      it 'should not raise error' do
        expect { subject }.to raise_error(ArgumentError, 'no node must be set in nodes[2]')
      end
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:parent) { AI::Node.new({}) }
      let(:elapsed) { 5 }
      let(:attributes) { { identifier: identifier, nodes: nodes, parent: parent, elapsed: elapsed } }

      it 'should set identifier' do
        expect(subject.identifier).to eq(identifier)
      end

      it 'should set parent' do
        expect(subject.parent).to eq(parent)
      end

      it 'should set elapsed' do
        expect(subject.elapsed).to eq(elapsed)
      end
    end

    context 'when term, yes and no are set' do
      let(:term) { term_failed }
      let(:yes) { action_succeeded }
      let(:no) { action_busy }

      it 'term, yes, no should be set' do
        expect(subject.child(term.identifier)).to eq(term)
        expect(subject.child(yes.identifier)).to eq(yes)
        expect(subject.child(no.identifier)).to eq(no)
      end
    end
  end

  describe '#start!' do
    subject { condition }
    before { condition.start! }

    it 'condition should be busy' do
      expect(subject.running?).to eq(true)
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#stop!' do
    subject { condition }
    before { condition.start!; condition.stop! }

    it 'condition should be stopped' do
      expect(subject.stopped?).to eq(true)
    end

    it 'term, yes, no should be stopped' do
      expect(term.stopped?).to eq(true)
      expect(yes.stopped?).to eq(true)
      expect(no.stopped?).to eq(true)
    end
  end

  describe '#process' do
    subject { condition.process(entity, world) }
    before { condition.start! }

    context 'when term resolve to :succeeded' do
      let(:term) { term_succeeded }

      it '' do
#        expect(condition).to receive(:handle_response)
      end

      context 'when executed node response is :succeeded' do
        let(:yes) { action_succeeded }
        let(:no) { action_failed }

        it 'should respond :succeeded' do
#          expect(condition).to receive(:handle_response) { :succeeded }
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when executed node response is :busy' do
        let(:yes) { action_busy }
        let(:no) { action_failed }

        it 'should respond :busy' do
#          expect(condition).to receive(:handle_response) { :busy }
          expect(subject.busy?).to eq(true)
        end
      end

      context 'when executed node response is :failed' do
        let(:yes) { action_failed }
        let(:no) { action_busy }

        it 'should be busy' do
          expect(condition).to receive(:handle_response) { :failed }
          expect(subject.failed?).to eq(true)
        end
      end
    end

    context 'when term resolve to :failed' do
      let(:term) { term_failed }

      context 'when executed node response is :succeeded' do
        let(:yes) { action_failed }
        let(:no) { action_succeeded }

        it 'should respond :succeeded' do
#          expect(condition).to receive(:handle_response) { :succeeded }
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when executed node response is :busy' do
        let(:yes) { action_failed }
        let(:no) { action_busy }

        it 'should respond :busy' do
          expect(subject.busy?).to eq(true)
        end
      end

      context 'when executed node response is :failed' do
        let(:yes) { action_busy }
        let(:no) { action_failed }

        it 'should respond :failed' do
          expect(subject.failed?).to eq(true)
        end
      end
    end
  end
end
