require 'araignee/architecture/entity'
require 'araignee/architecture/helpers/validator'

include Araignee::Architecture
include Araignee::Architecture::Helpers

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
end

class ValidatorImplError < Validator
  def validate_entity(klass: nil, entity: nil, context: nil)
    %w(a b)
  end
end

RSpec.describe Validator do
  let(:validator) { Validator.instance }

  describe '#validate' do
    context 'when implemented class' do
      let(:params) { { klass: Impl::Entity, entity: { name: 'joe' } } }
      let(:result) { validator.validate(params) }

      it 'should return a Validator::Result' do
        expect(result).to be_a(Validator::Result)
      end

      it 'should be successful' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when implemented class with errors' do
      let(:params) { { klass: Impl::Entity, entity: { name: 'joe' } } }
      let(:result) { ValidatorImplError.instance.validate(params) }

      it 'should return a Validator::Result' do
        expect(result).to be_a(Validator::Result)
      end

      it 'should not be successful' do
        expect(result.successful?).to eq(false)
      end

      it 'should have 2 messages' do
        expect(result.messages).to eq(%w(a b))
      end
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
      it 'should have 0 messages' do
        expect(result_error.messages).to eq([])
      end
    end

    context 'when messages are set' do
      before { result_error << %w(a b) }

      it 'successful? should return false' do
        expect(result_error.successful?).to eq(false)
      end
      it 'should have 2 messages' do
        expect(result_error.messages).to eq(%w(a b))
      end
    end
  end

  describe '#<<' do
    let(:result_error) { Validator::Result.new }

    context 'when messages are not set' do
      before { result_error << nil }

      it 'should have 0 messages' do
        expect(result_error.messages).to eq([])
      end
    end

    context 'when messages are empty' do
      before { result_error << [] }

      it 'should have 0 messages' do
        expect(result_error.messages).to eq([])
      end
    end

    context 'when messages are set' do
      before { result_error << %w(a b) }

      it 'should have 2 messages' do
        expect(result_error.messages).to eq(%w(a b))
      end
    end
  end
end
