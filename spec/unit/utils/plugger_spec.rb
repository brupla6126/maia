require 'araignee/utils/plugger'

include Araignee, Araignee::Utils

class EntityModel < Plugin
  def initialize(contracts = [], adapters = [])
    super
  end
end
class ActionsModel < EntityModel
  def initialize(contracts = [], adapters = [])
    super
  end

  def find
  end
end

RSpec.describe Plugger do
  describe '#reset' do
    context 'when resetting the plugin manager' do
      before :each do
        Plugger.reset
        Plugger.register Plugin.new
        Plugger.reset
      end

      it 'does not have plugins' do
        expect(Plugger.plugins.count).to eq(0)
      end
      it 'does not have contracts' do
        expect(Plugger.contracts.count).to eq(0)
      end
    end
  end

  describe '#register' do
    context 'when registering a plugin with the manager' do
      before :each do
        Plugger.reset
        Plugger.register Plugin.new
      end

      it 'plugins count equals 1' do
        expect(Plugger.plugins.count).to eq(1)
      end
      it 'plugin was registered' do
        expect(Plugger.plugins[:plugin]).not_to eq(nil)
      end
    end

    context 'when registering a plugin referring to unregistered contract' do
      let(:plugin) { Plugin.new [:unknown] }
      before :each do
        Plugger.reset
        Plugger.add_contract(:plugin, [])
      end

      it 'raises PluginContractError' do
        expect do
          Plugger.register plugin
        end.to raise_error(PluginContractError, 'Plugin referring to unregistered contract :unknown')
      end
    end

    context 'when registering a plugin that does not honor contract' do
      let(:plugin) { Plugin.new [:crud] }
      before :each do
        Plugger.reset
      end

      it 'raises PluginContractError' do
        expect do
          Plugger.add_contract(:crud, [:find])
          Plugger.register plugin
        end.to raise_error(PluginContractError, 'Plugin or its adapters do not honor contract :crud')
      end
    end
  end

  describe '#unregister' do
    context 'unregisters a plugin with the manager' do
      let(:plugin) { Plugin.new }
      before :each do
        Plugger.reset
      end

      it 'plugins count should equals 0' do
        Plugger.register plugin
        Plugger.unregister plugin
        expect(Plugger.plugins.count).to eq(0)
      end
      it 'plugin :plugin was unregistered' do
        Plugger.register plugin
        Plugger.unregister plugin
        expect(Plugger.plugins[:plugin]).to eq(nil)
      end
    end
  end

  describe '#honoring' do
    context 'when asking decendant plugins of :plugin honoring contract :plugin' do
      before :each do
        Plugger.reset
        Plugger.register Plugin.new
        @entity_model = EntityModel.new
        Plugger.register @entity_model
      end

      it 'plugin :plugin is honoring contract :plugin' do
        expect(Plugger.honoring(:plugin, [:configure])).to include(@entity_model)
      end
    end

    context 'when asking decendant plugins of :entity_model honoring contract :crud' do
      before :each do
        Plugger.reset
        Plugger.add_contract :crud, [:find]
        # Plugger.register Plugin.new
        Plugger.register EntityModel.new
        @actions_model = ActionsModel.new [:crud]
        Plugger.register @actions_model
      end

      it 'plugin :entity_model is honoring contract :plugin' do
        expect(Plugger.honoring(:entitymodel, [:find])).to include(@actions_model)
      end
    end
  end

  describe '#[]' do
    context 'it returns a plugin based on its name' do
      before :each do
        Plugger.reset
        Plugger.add_contract :crud, []
        Plugger.register EntityModel.new
      end

      it 'returned plugin not nil' do
        expect(Plugger[:entitymodel]).not_to eq(nil)
        expect(Plugger[:entitymodel].class).to eq(EntityModel)
      end
    end
  end
end
