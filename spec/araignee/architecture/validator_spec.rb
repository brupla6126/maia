require 'araignee/architecture/validator'

RSpec.describe Architecture::Validator do
  let(:validator) { Architecture::Validator.instance }
  let(:errors) { %w(a b) }
  let(:no_errors) { [] }

  describe '#validate' do
    let(:entity) { { name: 'joe' } }
    let(:context) { {} }
    let(:result) { validator.validate(entity, context) }

    context 'when not implemented class' do
      it 'should raise NotImplementedError' do
        expect { result }.to raise_error(NotImplementedError)
      end
    end

    context 'when implemented class' do
      context 'without errors' do
        before do
          allow_any_instance_of(Architecture::Validator).to receive(:validate_entity).and_return(no_errors)
        end

        it 'should return a Validator::Result' do
          expect(result).to be_a(Architecture::Validator::Result)
        end

        it 'should be successful' do
          expect(result.successful?).to eq(true)
        end
      end

      context 'with errors' do
        before do
          allow_any_instance_of(Architecture::Validator).to receive(:validate_entity).and_return(errors)
        end

        it 'should return a Validator::Result' do
          expect(result).to be_a(Architecture::Validator::Result)
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
end

RSpec.describe Architecture::Validator::Result do
  describe '#initialize' do
    let(:result) { Architecture::Validator::Result.new }

    it 'messages should be empty' do
      expect(result.messages.empty?).to eq(true)
    end
  end

  describe '#successful?' do
    let(:result) { Architecture::Validator::Result.new }
    let(:result_error) { Architecture::Validator::Result.new }

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
    let(:result_error) { Architecture::Validator::Result.new }

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
