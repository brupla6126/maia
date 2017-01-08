require 'araignee/architecture/aggregator'

include Araignee::Architecture

RSpec.describe Aggregator do
  describe '#execute' do
    it 'should raise NotImplementedError' do
      expect { Aggregator.execute(name: 'joe') }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    let(:user) { Aggregator.new(name: 'joe') }

    context 'when creating with attributes' do
      it 'should raise ArgumentError name must be set' do
        expect(user.attributes[:name]).to eq('joe')
      end
    end
  end

  describe '#create' do
    it 'should raise NotImplementedError' do
      expect { Aggregator.new({}).create }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe Aggregator::Result do
  describe '#initialize' do
    let(:result) { Aggregator::Result.new({}, []) }

    context 'when name not set' do
      it 'should raise ArgumentError name must be set' do
        expect(result.entity).to eq({})
        expect(result.messages).to eq([])
      end
    end
    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Aggregator::Result.new({}, []) }
    let(:result_error) { Aggregator::Result.new({}, ['error 1']) }

    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
      it 'successful? should return true' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when messages is set' do
      it 'successful? should return false' do
        expect(result_error.successful?).to eq(false)
      end
    end
  end
end
