require 'araignee/ai/state'

RSpec.describe AI::State do
  class Intro < AI::State
  end
  class Lobby < AI::State
  end
  class Play < AI::State
  end

  let(:play_state) { Play.new }
  let(:intro_state) { Intro.new }
  let(:lobby_state) { Lobby.new }

  before do
    AI::State.clear
  end

  describe '#current' do
    before do
      AI::State.push(play_state)
    end

    it 'verify a pushed State is the current one' do
      expect(AI::State.current).to eq(play_state)
      expect(AI::State.current.class).to eq(Play)
    end
  end

  describe '#push' do
    before do
      AI::State.push(play_state)
    end

    it 'StateList should have 1 State' do
      expect(AI::State.count).to eq(1)
    end
  end

  describe '#pop' do
    context 'when no State has been pushed' do
      it 'StateList should be empty' do
        expect(AI::State.count).to eq(0)
      end
    end

    context 'after a State has been pushed' do
      before do
        AI::State.push(play_state)
        AI::State.pop
      end

      it 'StateList should be empty' do
        expect(AI::State.count).to eq(0)
      end
    end
  end

  describe '#pop_until' do
    context 'when no State has been pushed' do
      before do
        AI::State.pop
      end

      it 'StateList should be empty' do
        expect(AI::State.count).to eq(0)
      end
    end

    context 'after some States have been pushed' do
      before do
        AI::State.push(intro_state)
        AI::State.push(lobby_state)
        AI::State.push(play_state)

        AI::State.pop_until(Intro)
      end

      it 'verify a StateList current State is Intro' do
        expect(AI::State.count).to eq(1)
        expect(AI::State.current).to eq(intro_state)
      end
    end
  end

  describe '#clear' do
    context 'when no State has been pushed' do
      before do
        AI::State.clear
      end

      it 'StateList should be empty' do
        expect(AI::State.count).to eq(0)
      end
    end

    context 'after some States have been pushed' do
      before do
        AI::State.push(intro_state)
        AI::State.push(lobby_state)
        AI::State.push(play_state)

        AI::State.clear
      end

      it 'StateList should be empty' do
        expect(AI::State.count).to eq(0)
      end
    end
  end
end
