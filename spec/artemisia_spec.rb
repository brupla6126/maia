RSpec.describe Artemisia::VERSION do
  it 'has a version number' do
    expect(Artemisia::VERSION).not_to be_nil
  end
end

RSpec.describe Artemisia do
  describe '::boot' do
    subject { described_class.boot }

    it 'has a version number' do
      # expect(Artemisia.engine).not_to be_nil
    end
  end

  describe '::setup' do
    subject { described_class.setup }

    it 'calls block' do
      expect(subject).to be_nil
    end
  end
end
