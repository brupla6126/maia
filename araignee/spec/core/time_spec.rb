require 'core/time'

RSpec.describe Time do
  describe 'to_ms' do
    let(:now) { Time.now }
    subject { now.to_ms }

    it 'should return number of milliseconds' do
      expect(subject).to eq((now.to_f * 1000.0).to_i)
    end
  end
end
