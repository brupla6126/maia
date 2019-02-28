require 'ostruct'
require 'artemisia/engine'

RSpec.describe Artemisia::Engine do
  let(:config_params) { {} }

  let(:config) { OpenStruct.new(config_params) }
  let(:context) { OpenStruct.new }

  let(:engine) { described_class.new(config: config, context: context) }

  subject { engine }

  describe '#initialize' do
    subject { super() }

    it 'sets context' do
      expect(subject.config).to eq(config)
      expect(subject.context).to eq(context)
      expect(subject.worlds).to eq([])
    end
  end

  describe '#boot' do
    subject { super().boot }

    let(:initializer_paths) { ['abc', 'abc'] }
    let(:factory_paths) { ['def'] }
    let(:template_paths) { ['ghi'] }

    let(:config_params) do
      { initializer_paths: initializer_paths,
        factory_paths: factory_paths,
        template_paths: template_paths }
    end

    it 'load initializers, factories and templates' do
      subject
    end

    it 'does not load files more than once' do
      expect(engine).to receive(:load_files).with((config.initializer_paths + config.factory_paths + config.template_paths).uniq)
      subject
    end
  end

  describe '#run' do
  end

  describe '#shutdown' do
    subject { super().shutdown }

    it 'sends :before_shutdown event' do
      expect(engine).to receive(:emit).with(:before_shutdown)
      expect(engine).to receive(:emit).with(:after_shutdown)
      subject
    end
  end
  #   describe '#worlds' do
  #     subject { super().worlds }
  #
  #     before { engine.clear }
  #
  #     context 'was not previously initialized' do
  #       it 'return empty hash' do
  #         expect(subject).to eq({})
  #       end
  #     end
  #
  #     context 'was previously initialized' do
  #       before { subject[:new_world] = new_world }
  #
  #       let(:new_world) { { a: 1 } }
  #
  #       it 'returns worlds' do
  #         expect(subject).to eq(new_world: new_world)
  #       end
  #     end
  #   end
  #
  #   describe '#world' do
  #     subject { super().world(world_id) }
  #
  #     let(:world_id) { nil }
  #
  #     context 'unknown world' do
  #       it 'return nil' do
  #         expect(subject).to be_nil
  #       end
  #     end
  #
  #     context 'known world' do
  #       before { engine.worlds[:new_world] = new_world }
  #
  #       let(:new_world) { { a: 1 } }
  #       let(:world_id) { :new_world }
  #
  #       it 'returns worlds' do
  #         expect(subject).to eq(new_world)
  #       end
  #     end
  #   end
  #
  #   describe '#add_world' do
  #     subject { super().add_world(world2) }
  #
  #     let(:world1) { Artemisia::World.new(:new_world) }
  #     let(:world2) { Artemisia::World.new(:old_world) }
  #
  #     context 'known world' do
  #       before { engine.worlds[world1.id] = world1 }
  #
  #       it 'has both worlds' do
  #         subject
  #         expect(engine.worlds.count).to eq(2)
  #         expect(engine.worlds.values).to include(world1)
  #         expect(engine.worlds.values).to include(world2)
  #       end
  #     end
  #   end
  #
  #   describe '#remove_world' do
  #     subject { super().remove_world(world2) }
  #
  #     let(:world1) { Artemisia::World.new(:new_world) }
  #     let(:world2) { Artemisia::World.new(:old_world) }
  #
  #     context 'unknown world' do
  #       before { engine.worlds[world1.id] = world1 }
  #
  #       it 'removes world' do
  #         subject
  #
  #         expect(engine.worlds.count).to eq(1)
  #         expect(engine.worlds.values).to include(world1)
  #         expect(engine.worlds.values).not_to include(world2)
  #       end
  #
  #       it 'returns nil' do
  #         expect(subject).to be_nil
  #       end
  #     end
  #
  #     context 'known world' do
  #       before { engine.worlds[world1.id] = world1 }
  #       before { engine.worlds[world2.id] = world2 }
  #
  #       it 'removes world' do
  #         subject
  #
  #         expect(engine.worlds.count).to eq(1)
  #         expect(engine.worlds.values).to include(world1)
  #         expect(engine.worlds.values).not_to include(world2)
  #       end
  #
  #       it 'returns removed world' do
  #         expect(subject).to eq(world2)
  #       end
  #     end
  #   end
end
