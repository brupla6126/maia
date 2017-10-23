require 'araignee/architecture/client'
require 'araignee/utils/plugger'

RSpec.describe Architecture::Client do
  describe '#initialize' do
    let(:client1) { Architecture::Client.new }

    context 'initializes a client with no contract and no adapters' do
      it 'name should be generated from classname' do
        expect(client1.name).to eq(:client)
      end
      it 'should have contracts [:plugin, :client]' do
        expect(client1.contracts).to eq(%i[plugin client])
      end
      it 'should have no adapters' do
        expect(client1.adapters).to eq([])
      end
    end
  end

  describe '#configure' do
    let(:adapter) { double('adapter') }
    let(:client) { Architecture::Client.new([], [adapter]) }

    before do
      Plugger.add_contract(:client, %i[initiate terminate])
    end

    context 'when configuring a client with adapters' do
      it 'adapters should be configured' do
        expect(adapter).to receive(:configure).once
        client.configure({})
      end
    end
  end

  describe '#initiate' do
    let(:adapter) { double('adapter') }
    let(:client) { Architecture::Client.new([], [adapter]) }

    before do
      Plugger.add_contract(:client, %i[initiate terminate])
    end

    context 'when initiating a client with adapters' do
      it 'adapters should be initiated' do
        expect(adapter).to receive(:initiate).once
        client.initiate
      end
    end
  end

  describe '#terminate' do
    let(:adapter) { double('adapter') }
    let(:client) { Architecture::Client.new([], [adapter]) }

    before do
      Plugger.add_contract(:client, %i[initiate terminate])
    end

    context 'when terminating a client with adapters' do
      it 'adapters should be terminated' do
        expect(adapter).to receive(:terminate).once
        client.terminate
      end
    end
  end
end
