require 'araignee/architecture/entity'

include Araignee::Architecture

class User < Entity
  attribute :name, String, default: ''
  attribute :age, Integer, default: 0

  def validate_attributes
    raise ArgumentError, 'name must be set' if name.empty?
  end
end

RSpec.describe Araignee::Architecture::Entity do
  describe '#initialize' do
    let(:user) { User.new(name: 'joe') }

    context 'when name not set' do
      it 'should raise ArgumentError name must be set' do
        expect { User.new }.to raise_error(ArgumentError, 'name must be set')
      end
    end
    context 'when age not set' do
      it 'should default to 0' do
        expect(user.age).to eq(0)
      end
    end
  end
end
