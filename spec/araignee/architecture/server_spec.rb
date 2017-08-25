require 'araignee/architecture/server'
require 'araignee/utils/plugger'

RSpec.describe Architecture::Server do
  class ControllerTest
    def configure(config)
    end

    def action
    end
  end

  describe '#initialize' do
    let(:server1) { Architecture::Server.new }

    context 'initializes a server with no contract and no adapters' do
      it 'name should be generated from classname' do
        expect(server1.name).to eq(:server)
      end
      it 'should have contracts [:plugin, :server]' do
        expect(server1.contracts).to eq([:plugin, :server])
      end
      it 'should have no adapters' do
        expect(server1.adapters).to eq([])
      end
    end
  end

  describe '#configure' do
    let(:adapter) { double('adapter') }
    let(:server) { Architecture::Server.new([], [adapter]) }

    before do
      Plugger.add_contract(:server, [:initiate, :terminate])
    end

    context 'when configuring a server with adapters' do
      it 'adapters should be configured' do
        expect(adapter).to receive(:configure).once
        server.configure({})
      end
    end

    context 'when configuring a server with one controller' do
      before do
        server.configure(
          server: {
            controllers: {
              controller: ControllerTest
            }
          }
        )
      end
      it 'controllers should be configured' do
        server.configure({})
        expect(server.controllers.size).to eq(1)
      end
    end
  end

  describe '#initiate' do
    let(:adapter) { double('adapter') }
    let(:server) { Architecture::Server.new([], [adapter]) }

    before do
      Plugger.add_contract(:server, [:initiate, :terminate])
    end

    context 'when initiating a server with adapters' do
      it 'adapters should be initiated' do
        expect(adapter).to receive(:initiate).once
        server.initiate
      end
    end
  end

  describe '#terminate' do
    let(:adapter) { double('adapter') }
    let(:server) { Architecture::Server.new([], [adapter]) }

    before do
      Plugger.add_contract(:server, [:initiate, :terminate])
    end

    context 'when terminating a server with adapters' do
      it 'adapters should be terminated' do
        expect(adapter).to receive(:terminate).once
        server.terminate
      end
    end
  end

  describe '#operation_supported?' do
    let(:server) { Architecture::Server.new }

    before do
      Plugger.add_contract(:server, [:initiate, :terminate])
      server.controllers[:object] = ControllerTest.new
    end

    context 'when controller handles operation :action' do
      it 'operation :action should be supported' do
        expect(server.operation_supported?(:object, :action)).to eq(true)
      end
    end
  end

  describe '#execute' do
    let(:controller) { double('adapter') }
    let(:server) { Architecture::Server.new }

    before do
      Plugger.add_contract(:server, [:initiate, :terminate])
      server.controllers[:object] = controller
    end

    context 'when controller handles operation :action' do
      it 'operation :action should be supported' do
        expect(controller).to receive(:action).once
        server.execute(:object, :action, {})
      end
    end
  end
end
