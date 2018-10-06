require 'gamia'

RSpec.describe Gamia do
  describe '::VERSION' do
    it 'is set' do
      expect(Gamia::VERSION).not_to be_nil
    end
  end

  describe '::root' do
    subject { described_class.root }

    let(:dir) { 'dir' }

    before { allow(Dir).to receive(:pwd) { dir } }

    it 'returns current directory' do
      expect(subject).to eq(dir)
    end
  end
end
