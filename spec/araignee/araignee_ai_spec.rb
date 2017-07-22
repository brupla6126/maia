RSpec.describe Araignee do
  describe 'require araignee_ai' do
    it 'should not raise error' do
      expect { require 'araignee_ai' }.not_to raise_error
    end
  end
end
