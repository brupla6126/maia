require 'araignee/architecture/output_boundary'

include Araignee::Architecture

RSpec.describe OutputBoundary do
  describe '#process' do
    let(:output) { OutputBoundary.new }

    it 'should raise NotImplementedError' do
      expect { output.process({}, {}) }.to raise_error(NotImplementedError)
    end
  end
end
