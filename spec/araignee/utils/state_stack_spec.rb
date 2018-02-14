require 'araignee/utils/state_stack'

RSpec.describe StateStack do
  let(:state_stack) { described_class.new }

  let(:play_state) { double('[play]') }
  let(:rest_state) { double('[rest]') }
  let(:eat_state) { double('[eat]') }

  before { allow(eat_state).to receive(:enter) }
  before { allow(play_state).to receive(:enter) }
  before { allow(rest_state).to receive(:enter) }

  describe '#initialize' do
    subject { state_stack }

    it 'stack is empty' do
      expect(state_stack.states.empty?).to eq(true)
    end
  end

  describe '#current' do
    context 'without states' do
      it 'should return nil' do
        expect(state_stack.current).to eq(nil)
      end
    end

    context 'with states' do
      before { state_stack.push(play_state) }

      it 'verify the pushed State is the current one' do
        expect(state_stack.current).to eq(play_state)
      end
    end
  end

  describe '#push' do
    subject { state_stack.push(eat_state) }

    context 'without states pushed' do
      it 'stack has 1 state' do
        subject
        expect(state_stack.count).to eq(1)
      end

      context 'calls #enter on state pushed' do
        before { allow(eat_state).to receive(:enter) }

        it 'enters pushed state' do
          expect(eat_state).to receive(:enter)
          subject
        end
      end
    end

    context 'with one state already pushed' do
      before { allow(play_state).to receive(:pause) }

      before { state_stack.push(play_state) }

      it 'stack has 2 states' do
        subject
        expect(state_stack.count).to eq(2)
      end

      context 'calls #pause on current state' do
        before { allow(play_state).to receive(:pause) }

        it 'pauses current state' do
          expect(play_state).to receive(:pause)
          subject
        end
      end

      context 'calls #enter on state pushed' do
        before { allow(eat_state).to receive(:enter) }

        it 'enters pushed state' do
          expect(eat_state).to receive(:enter)
          subject
        end
      end
    end
  end

  describe '#pop' do
    subject { state_stack.pop }

    context 'without states pushed' do
      it 'stack is empty' do
        subject
        expect(state_stack.count).to eq(0)
      end
    end

    context 'with one state already pushed' do
      before { allow(play_state).to receive(:leave) }

      before { state_stack.push(play_state) }

      it 'stack is empty' do
        subject
        expect(state_stack.count).to eq(0)
      end

      context 'calls #leave on current state' do
        it 'leaves current state' do
          expect(play_state).to receive(:leave)
          subject
        end
      end
    end

    context 'with two states already pushed' do
      before { allow(play_state).to receive(:pause) }
      before { allow(play_state).to receive(:resume) }
      before { allow(eat_state).to receive(:leave) }

      before { state_stack.push(play_state) }
      before { state_stack.push(eat_state) }

      it 'stack has 1 state' do
        subject
        expect(state_stack.count).to eq(1)
      end

      context 'leaves current state and resume new current state' do
        it 'leaves current state' do
          expect(eat_state).to receive(:leave)
          subject
        end

        it 'resume new current state' do
          expect(play_state).to receive(:resume)
          subject
        end
      end
    end
  end

  describe '#pop_until' do
    subject { state_stack.pop_until(until_state) }

    let(:until_state) { nil }

    context 'without states pushed' do
      it 'stack is empty' do
        subject
        expect(state_stack.count).to eq(0)
      end
    end

    context 'with states already pushed' do
      before { allow(rest_state).to receive(:pause) }
      before { allow(play_state).to receive(:pause) }
      before { allow(play_state).to receive(:resume) }
      before { allow(eat_state).to receive(:leave) }

      before do
        state_stack.push(rest_state)
        state_stack.push(play_state)
        state_stack.push(eat_state)
      end

      let(:until_state) { play_state }

      it 'stack has 2 states' do
        subject
        expect(state_stack.count).to eq(2)
      end

      it 'current state is ok' do
        subject
        expect(state_stack.current).to eq(play_state)
      end

      context 'leaves current state and resume new current state' do
        it 'leaves current state' do
          expect(eat_state).to receive(:leave)
          subject
        end

        it 'resume new current state' do
          expect(play_state).to receive(:resume)
          subject
        end
      end

      context 'with unknown state' do
        let(:until_state) { double('[unknown]') }

        it 'stack has 3 states' do
          subject
          expect(state_stack.count).to eq(3)
        end
      end
    end
  end

  describe '#count' do
    subject { state_stack.count }

    context 'without states pushed' do
      it 'stack is empty' do
        expect(subject).to eq(0)
      end
    end

    context 'with states already pushed' do
      before { allow(rest_state).to receive(:pause) }

      before do
        state_stack.push(rest_state)
        state_stack.push(play_state)
      end

      it 'stack has pushed states' do
        expect(subject).to eq(2)
      end
    end
  end

  describe '#clear' do
    subject { state_stack.clear }

    context 'without states pushed' do
      it 'stack is empty' do
        expect(state_stack.count).to eq(0)
      end
    end

    context 'with states already pushed' do
      before { allow(rest_state).to receive(:pause) }

      before do
        state_stack.push(rest_state)
        state_stack.push(play_state)
      end

      it 'stack is empty' do
        subject
        expect(state_stack.count).to eq(0)
      end
    end
  end
end
