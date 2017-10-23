require 'araignee/architecture/network'

RSpec.describe Architecture::Network do
  describe '#local_ip' do
    it 'local ip is 192.168.1.2' do
      expect(Architecture::Network.local_ip).to eq('192.168.1.2')
    end
  end
end
