require 'araignee/architecture/finder'

include Araignee, Araignee::Architecture

RSpec.describe Finder do
  describe '#execute' do
    it 'should raise NotImplementedError' do
      expect { Finder.execute(name: 'joe') }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    let(:user) { Finder.new(name: 'joe') }

    context 'when creating with filters' do
      it 'should raise ArgumentError name must be set' do
        expect(user.filters[:name]).to eq('joe')
      end
    end
  end

  describe '#find' do
    it 'should raise NotImplementedError' do
      expect { Finder.new({}).find }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe Finder::Result do
  describe '#initialize' do
    let(:result) { Finder::Result.new({}, []) }

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
    let(:result) { Finder::Result.new({}, []) }
    let(:result_error) { Finder::Result.new({}, ['error 1']) }

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
