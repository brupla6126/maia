require 'araignee'

RSpec.describe Araignee do
  describe 'require araignee.rb' do
    it 'do not raise error' do
      expect { require 'araignee' }.not_to raise_error
    end
  end

  describe '::VERSION' do
    it 'is set' do
      expect(Araignee::VERSION).not_to be(nil)
    end
  end

  describe '::root' do
    subject { Araignee.root }

    let(:dir) { 'dir' }

    before { allow(Dir).to receive(:pwd) { dir } }

    it 'returns current directory' do
      expect(subject).to eq(dir)
    end
  end
end
