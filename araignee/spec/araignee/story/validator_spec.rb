require 'araignee/story/validator'

RSpec.describe Araignee::Story::Validator do
  class MyValidator < described_class
    def validate_object(_object, _context, response)
      response.errors = []
    end
  end

  let(:validator) { MyValidator.new }

  subject { validator }

  describe '#validate' do
    subject { super().validate(object, context) }

    let(:object) { { name: 'joe' } }
    let(:context) { :create }

    it 'returns the response' do
      expect(subject.errors).to eq([])
    end
  end
end
