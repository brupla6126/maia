require 'araignee/architecture/creator'

include Araignee::Architecture

class CreatorImpl < Creator
  def create
    Result.new(@attributes)
  end
end

RSpec.describe Creator do
  describe '#execute' do
    context 'when abstract class' do
      it 'should raise NotImplementedError' do
        expect { Creator.instance.execute(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end
    context 'when implemented class' do
      let(:result) { CreatorImpl.instance.execute(name: 'joe') }

      it 'should return a Creator::Result' do
        expect(result).to be_a(Creator::Result)
      end

      it 'should be successful' do
        expect(result.successful?).to eq(true)
      end
    end
  end
end

RSpec.describe Creator::Result do
  describe '#initialize' do
    let(:result) { Creator::Result.new({}, []) }

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
    let(:result) { Creator::Result.new({}, []) }
    let(:result_error) { Creator::Result.new({}, ['error 1']) }

    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
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
