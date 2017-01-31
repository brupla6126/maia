RSpec.describe Araignee do
  describe 'require araignee_utils' do
    it 'should not raise error' do
      expect { require 'araignee_utils' }.not_to raise_error
    end
  end
end
