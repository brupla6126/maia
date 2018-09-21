require 'artemisia/engine'

RSpec.describe Artemisia::Engine do
  let(:engine) { described_class.new(context) }

  let(:context) { Artemisia::Context.new(config) }
  let(:config) { OpenStruct.new(config_params) }

  let(:config_params) { {} }

  subject { engine }

  describe '#initialize' do
    subject { super() }

    it 'sets context' do
      expect(subject.context).to eq(context)
      expect(subject.worlds).to eq([])
    end
  end

  describe '#boot' do
    subject { super().boot }

    let(:config_params) do
      { initializers_path: initializers_path,
        factories_paths: factories_paths,
        templates_paths: templates_paths }
    end
    let(:initializers_path) { 'abc' }
    let(:factories_paths) { ['def'] }
    let(:templates_paths) { ['ghi'] }

    it 'load initializers' do
      expect(engine).to receive(:load_initializers).with(config.initializers_path)
      subject
    end

    it 'load factories' do
      expect(engine).to receive(:load_factories).with(config.factories_paths)
      subject
    end

    it 'load factories' do
      expect(engine).to receive(:load_templates).with(config.templates_paths)
      subject
    end
  end

  describe '#run' do
  end

  describe '#shutdown' do
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
