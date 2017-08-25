describe Araignee do
  describe 'require araignee.rb' do
    it 'should not raise error' do
      expect { require 'araignee' }.not_to raise_error
    end

    describe 'Araignee::VERSION' do
      it 'Araignee::VERSION should be set' do
        expect(Araignee::VERSION).not_to be(nil)
      end
    end
  end
end
