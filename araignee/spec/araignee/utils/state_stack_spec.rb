require 'araignee/utils/state_stack'

RSpec.describe Araignee::Utils::StateStack do
  subject { state_stack }

  let(:state_stack) { described_class.new }

  let(:play_state) { double('[play]') }
  let(:rest_state) { double('[rest]') }
  let(:eat_state) { double('[eat]') }

  # before { allow(eat_state).to receive(:enter) }
  # before { allow(play_state).to receive(:enter) }
  # before { allow(rest_state).to receive(:enter) }

  describe '#initialize' do
    it 'stack is empty' do
      expect(state_stack.states.empty?).to eq(true)
    end
  end

  describe '#current' do
    subject { super().current }

    context 'without states' do
      it { is_expected.to eq(nil) }
    end

    context 'with states' do
      before do
        state_stack.states << rest_state
        state_stack.states << play_state
      end

      it 'verify the last pushed State is the current one' do
        is_expected.to eq(play_state)
      end
    end
  end

  describe '#push' do
    subject { super().push(pushed_stated) }

    before { allow(pushed_stated).to receive(:enter) }

    context 'without states pushed' do
      let(:pushed_stated) { play_state }

      it 'stack has 1 state' do
        subject
        expect(state_stack.states.count).to eq(1)
        expect(state_stack.states.last).to eq(pushed_stated)
      end

      it 'enters pushed state' do
        expect(pushed_stated).to receive(:enter)
        subject
      end
    end

    context 'with one state already pushed' do
      before { allow(play_state).to receive(:pause) }

      before { state_stack.states << play_state }

      let(:pushed_stated) { rest_state }

      it 'stack has 2 states' do
        subject
        expect(state_stack.states.count).to eq(2)
        expect(state_stack.states.last).to eq(pushed_stated)
      end

      it 'pauses current state and enters pushed state' do
        expect(play_state).to receive(:pause)
        expect(pushed_stated).to receive(:enter)
        subject
      end
    end
  end

  describe '#pop' do
    subject { super().pop }

    context 'without states pushed' do
      it 'stack is empty' do
        subject
        expect(state_stack.states.count).to eq(0)
      end
    end

    context 'with one state already pushed' do
      before { allow(play_state).to receive(:leave) }

      before { state_stack.states << play_state }

      it 'stack is empty' do
        subject
        expect(state_stack.states.count).to eq(0)
      end

      it 'leaves current state' do
        expect(play_state).to receive(:leave)
        subject
      end
    end

    context 'with two states already pushed' do
      before { allow(rest_state).to receive(:resume) }
      before { allow(eat_state).to receive(:leave) }

      before do
        state_stack.states << play_state
        state_stack.states << rest_state
        state_stack.states << eat_state
      end

      it 'stack has 1 state' do
        subject
        expect(state_stack.states.count).to eq(2)
        expect(state_stack.states).not_to include(eat_state)
        expect(state_stack.states.last).to eq(rest_state)
      end

      it 'leaves current state and resumes new current state' do
        expect(eat_state).to receive(:leave)
        expect(rest_state).to receive(:resume)
        subject
      end
    end
  end

  describe '#pop_until' do
    subject { super().pop_until(until_state) }

    before { allow(state_stack).to receive(:pop) { state_stack.states.pop } }

    let(:until_state) { nil }

    context 'without states pushed' do
      it 'stack is empty' do
        subject
        expect(state_stack.states.count).to eq(0)
      end

      it 'pop not called' do
        expect(state_stack).not_to receive(:pop)
        subject
      end
    end

    context 'with states already pushed' do
      before do
        state_stack.states << rest_state
        state_stack.states << play_state
        state_stack.states << eat_state
      end

      context 'with unknown state' do
        let(:until_state) { double('[unknown]') }

        it 'stack does not change' do
          subject
          expect(state_stack.states.count).to eq(3)
          expect(state_stack.states.last).to eq(eat_state)
        end

        it 'pop not called' do
          expect(state_stack).not_to receive(:pop)
          subject
        end
      end

      context 'with known state' do
        let(:until_state) { rest_state }

        it 'stack has 1 state' do
          subject
          expect(state_stack.states.count).to eq(1)
          expect(state_stack.states.last).to eq(rest_state)
        end

        it 'pop called twice' do
          expect(state_stack).to receive(:pop).exactly(2).times
          subject
        end
      end
    end
  end
end
