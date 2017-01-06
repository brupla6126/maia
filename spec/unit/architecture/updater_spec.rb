require 'araignee/architecture/updater'

include Araignee, Araignee::Architecture

RSpec.describe Updater do
  describe '#execute' do
    it 'should raise NotImplementedError' do
      expect { Updater.execute(1, name: 'joe') }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    let(:user) { Updater.new(1, name: 'joe') }

    context 'when creating with attributes' do
      it 'should raise ArgumentError name must be set' do
        expect(user.attributes[:name]).to eq('joe')
      end
    end
  end

  describe '#update' do
    it 'should raise NotImplementedError' do
      expect { Updater.new(1, {}).update }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe Updater::Result do
  describe '#initialize' do
    let(:result) { Updater::Result.new(1, {}, []) }

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
    let(:result) { Updater::Result.new(1, {}, []) }
    let(:result_error) { Updater::Result.new(1, {}, ['error 1']) }

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
