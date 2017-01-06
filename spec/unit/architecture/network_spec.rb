require 'araignee/architecture/network'

include Araignee::Architecture

RSpec.describe Araignee::Architecture::Network do
  describe '#local_ip' do
    it 'local ip is 192.168.1.3' do
      expect(Network.local_ip).to eq('192.168.1.3')
    end
  end
end
