require 'araignee/architecture/input_boundary'

include Araignee::Architecture

RSpec.describe InputBoundary do
  describe '#process' do
    let(:input) { InputBoundary.new }

    it 'should raise NotImplementedError' do
      expect { input.process({}, nil, {}) }.to raise_error(NotImplementedError)
    end
  end
end
