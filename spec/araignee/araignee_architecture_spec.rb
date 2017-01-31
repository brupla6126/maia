RSpec.describe Araignee do
  describe 'require araignee_architecture' do
    it 'should not raise error' do
      expect { require 'araignee_architecture' }.not_to raise_error
    end
  end
end
