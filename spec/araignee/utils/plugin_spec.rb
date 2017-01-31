require 'araignee/utils/plugin'

include Araignee, Araignee::Utils

class EntityModel < Plugin
end

class Actions < Plugin
  def initialize(contracts = [:crud], adapters = [])
    super
  end
end

class ActionsAdapter < Actions
  def find
  end
end

class ModelFake < Plugin
  def initialize(contracts = [:crud], adapters = [])
    super
  end
end

RSpec.describe Utils::Plugin do
  describe '#initialize' do
    let(:plugin) { Plugin.new([:one]) }
    let(:plugin_1c_0a) { Plugin.new([:crud]) }
    let(:plugin_1c_1a) { Plugin.new([:crud], [Plugin.new([:one])]) }

    context 'initializes a plugin with no contract and no adapters' do
      it 'name should be generated from classname' do
        expect(plugin.name).to eq(:plugin)
      end
      it 'should have contract [:plugin]' do
        expect(plugin.contracts).to eq([:plugin, :one])
      end
      it 'should have no adapters' do
        expect(plugin.adapters).to eq([])
      end
    end

    context 'initializes a plugin with contract :crud and no adapters' do
      it 'should have two contracts [:plugin, :crud]' do
        expect(plugin_1c_0a.contracts).to eq([:plugin, :crud])
      end
      it 'should have adapters' do
        expect(plugin_1c_0a.adapters.length).to eq(0)
      end
    end

    context 'initializes a plugin with contract :crud and one adapter' do
      it 'should have two contracts [:plugin, :crud]' do
        expect(plugin_1c_1a.contracts).to eq([:plugin, :crud])
      end
      it 'should not have adapters' do
        expect(plugin_1c_1a.adapters.length).to eq(1)
      end
    end
  end

  describe '#honor_contract?' do
    let(:contract_plugin) { [:configure] }
    let(:contract_crud) { [:find] }
    let(:plugin) { Plugin.new([:plugin]) }
    let(:entity_model) { EntityModel.new([:one]) }
    let(:actions) { Actions.new [:plugin], [ActionsAdapter.new] }
    let(:model_fake) { ModelFake.new }

    context 'when honoring contract from instance' do
      it 'returns true' do
        expect(entity_model.honor_contract?(contract_plugin)).to eq(true)
      end
    end

    context 'when plugin honors contract from adapters' do
      it 'returns true' do
        expect(actions.honor_contract?(contract_crud)).to eq(true)
      end
    end

    context 'when plugin does not honors contract' do
      it 'returns false' do
        expect(model_fake.honor_contract?(contract_crud)).to eq(false)
      end
    end
  end

  describe '#configure' do
    let(:plugin) { Plugin.new([:one]) }
    let(:em) { EntityModel.new }
    let(:actions) { Actions.new }
    let(:plugin_adapters) { Plugin.new([], [em, actions]) }

    context 'when configuring a plugin' do
      it 'configure() should be called once' do
        plugin.configure({})
      end
    end

    context 'when configuring a plugin with adapters' do
      it 'adapters should be configured' do
        adapter = double('adapter')

        plugin = Plugin.new([:one], [adapter])

        expect(adapter).to receive(:configure).once
        plugin.configure({})
      end
    end
  end

  describe '#contract' do
    context 'when asking :crud contract' do
      it 'returns [:exists?, :one, :all, :create, :update, :delete]' do
        expect(Plugin.contract(:crud)).to eq([:exists?, :one, :all, :create, :update, :delete])
      end
    end

    context 'when asking :plugin contract' do
      it 'returns [:configure]' do
        expect(Plugin.contract(:plugin)).to eq([:configure])
      end
    end

    context 'when asking unsupported contract' do
      it 'returns []' do
        expect(Plugin.contract(:unknown)).to eq([])
      end
    end
  end
end
