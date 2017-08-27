require 'araignee/utils/state'

RSpec.describe State do
  let(:play_state) { double('[play]') }
  let(:rest_state) { double('[rest]') }
  let(:eat_state) { double('[eat]') }

  before { State.clear }
  before { allow(play_state).to receive(:enter) }
  before { allow(play_state).to receive(:leave) }
  before { allow(rest_state).to receive(:enter) }
  before { allow(rest_state).to receive(:pause) }
  before { allow(eat_state).to receive(:enter) }
  before { allow(eat_state).to receive(:pause) }
  before { allow(eat_state).to receive(:resume) }

  describe '#current' do
    context 'without current state' do
      it 'should return nil' do
        expect(State.current).to eq(nil)
      end
    end

    context 'with current state' do
      before { State.push(play_state) }

      it 'verify the pushed State is the current one' do
        expect(State.current).to eq(play_state)
      end
    end
  end

  describe '#push' do
    context 'when no State has been pushed' do
      before { State.push(eat_state) }

      it 'States list should have 1 State' do
        expect(State.count).to eq(1)
        expect(eat_state).to have_received(:enter)
      end
    end

    context 'when one State was already pushed' do
      before { State.push(eat_state) }
      before { State.push(play_state) }

      it 'States list should have 2 States' do
        expect(State.count).to eq(2)
        expect(play_state).to have_received(:enter)
      end

      it 'current State method pause should be called' do
        expect(eat_state).to have_received(:pause)
      end

      it 'new pushed State method enter should be called' do
        expect(play_state).to have_received(:enter)
      end
    end
  end

  describe '#pop' do
    context 'when no State has been pushed' do
      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end
    end

    context 'after a State has been pushed' do
      before { State.push(play_state) }
      before { State.pop }

      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end

      it 'pushed State method leave should be called' do
        expect(play_state).to have_received(:leave)
      end
    end

    context 'after a State has been pushed' do
      before { State.push(eat_state) }
      before { State.push(play_state) }
      before { State.pop }

      it 'States list should have one state' do
        expect(State.count).to eq(1)
      end

      it 'popped State method leave should be called' do
        expect(play_state).to have_received(:leave)
      end

      it 'new current State method resume should be called' do
        expect(eat_state).to have_received(:resume)
      end
    end
  end

  describe '#pop_until' do
    context 'when no State has been pushed' do
      before { State.pop }

      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end
    end

    context 'after some States have been pushed' do
      before do
        State.push(rest_state)
        State.push(eat_state)
        State.push(play_state)

        State.pop_until(eat_state)
      end

      it 'current State is eat_state' do
        expect(State.count).to eq(2)
        expect(State.current).to eq(eat_state)
      end

      it 'popped State method leave should be called' do
        expect(play_state).to have_received(:leave)
      end

      it 'new current State method resume should be called' do
        expect(eat_state).to have_received(:resume)
      end
    end
  end

  describe '#count' do
    context 'when no State has been pushed' do
      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end
    end

    context 'after some States have been pushed' do
      before { State.push(rest_state) }

      it 'States list should have one state' do
        expect(State.count).to eq(1)
      end
    end
  end

  describe '#clear' do
    context 'when no State has been pushed' do
      before { State.clear }

      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end
    end

    context 'after some States have been pushed' do
      before do
        State.push(rest_state)
        State.push(eat_state)
        State.push(play_state)

        State.clear
      end

      it 'States list should be empty' do
        expect(State.count).to eq(0)
      end
    end
  end

  describe 'State instance' do
    before { allow(Log).to receive(:info) }
    subject { State.new }

    context 'enter' do
      before { subject.enter }

      it 'method has been called' do
        expect(Log).to have_received(:info)
      end
    end

    context 'leave' do
      before { subject.leave }

      it 'method has been called' do
        expect(Log).to have_received(:info)
      end
    end

    context 'pause' do
      before { subject.pause }

      it 'method has been called' do
        expect(Log).to have_received(:info)
      end
    end

    context 'resume' do
      before { subject.resume }

      it 'method has been called' do
        expect(Log).to have_received(:info)
      end
    end
  end
end
