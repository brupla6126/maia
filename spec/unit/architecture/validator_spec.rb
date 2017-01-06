require 'araignee/architecture/validator'

include Araignee, Araignee::Architecture

class ValidatorImplemented < Validator
  def validate_entity
  end
end

RSpec.describe Validator do
  describe '#execute' do
    it 'should raise NotImplementedError' do
      expect { Validator.execute(name: 'joe') }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    let(:validator) { Validator.new(name: 'joe') }

    context 'when creating with entity' do
      it 'entity should be set' do
        expect(validator.entity).to be_a(Hash)
        expect(validator.entity[:name]).to eq('joe')
      end
    end
  end

  describe '#validate' do
    let(:validator) { ValidatorImplemented.new(name: 'joe') }

    it 'should return a Validator::Result' do
      expect(validator.validate).to be_a(Validator::Result)
    end

    it 'validation should be successful' do
      expect(validator.validate.successful?).to eq(true)
    end
  end
end

RSpec.describe Validator::Result do
  describe '#initialize' do
    let(:result) { Validator::Result.new }

    it 'messages should be empty' do
      expect(result.messages.empty?).to eq(true)
    end
  end

  describe '#successful?' do
    let(:result) { Validator::Result.new }
    let(:result_error) { Validator::Result.new }

    context 'when messages not set' do
      it 'successful? should return true' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when messages are set' do
      before { result_error << 'error 2' }

      it 'should have 1 message' do
        expect(result_error.messages.size).to eq(1)
      end
      it 'successful? should return false' do
        expect(result_error.successful?).to eq(false)
      end
    end
  end
end
