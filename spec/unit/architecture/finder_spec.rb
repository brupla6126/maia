require 'araignee/architecture/finder'

include Araignee::Architecture

RSpec.describe Finder do
  describe '#execute' do
    context 'when with filters' do
      it 'should raise NotImplementedError' do
        expect { Finder.instance.execute(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end

    context 'when without filters' do
      it 'should raise ArgumentError, filters empty' do
        expect { Finder.instance.execute({}) }.to raise_error(ArgumentError, 'filters empty')
      end
    end
  end
end

RSpec.describe Finder::Result do
  describe '#initialize' do
    context 'when filters empty' do
      it 'should raise ArgumentError filters must be set' do
        expect { Finder::Result.new({}, [], []) }.to raise_error(ArgumentError, 'filters must be set')
      end
    end

    context 'when filters not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, [], []) }
      it 'result filters should be set' do
        expect(result.filters).to eq(a: 1)
      end
    end

    context 'when entities set empty' do
      let(:result) { Finder::Result.new({ a: 1 }, [], []) }
      it 'result entities should be empty' do
        expect(result.entities).to eq([])
      end
    end

    context 'when entities not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, [1], []) }
      it 'result entities should be set' do
        expect(result.entities).to eq([1])
      end
    end

    context 'when messages set empty' do
      let(:result) { Finder::Result.new({ a: 1 }, [1], []) }
      it 'result messages should equal []' do
        expect(result.messages).to eq([])
      end
    end

    context 'when messages not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, [1], ['abc']) }
      it 'result messages should be set' do
        expect(result.messages).to eq(['abc'])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Finder::Result.new({ a: 1 }, [], []) }
    let(:result_error) { Finder::Result.new({ a: 1 }, [], ['error 1']) }

    context 'when messages empty' do
      it 'should return true' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when messages is set' do
      it 'should return false' do
        expect(result_error.successful?).to eq(false)
      end
    end
  end
end
