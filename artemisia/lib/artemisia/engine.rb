require 'araignee/utils/emitter'

module Artemisia
  class Engine
    include Araignee::Utils::Emitter

    attr_reader :config, :context, :worlds

    def initialize(config:, context:)
      @config = config
      @context = context
      @worlds = []
    end

    def boot
      load_files((@config.initializer_paths + @config.factory_paths + @config.template_paths).uniq)

      # load worlds
      # subscribe
    end

    def run
      # loop
    end

    def shutdown
      emit(:before_shutdown)
      # cleanup
      emit(:after_shutdown)
    end

    private

    def load_files(paths)
      paths.each do |path|
        require_files(File.join(path, '**', '*.rb'))
      end
    end

    def require_files(file_filter)
      Dir.glob(file_filter).each { |file| require file }
    end
    #     def self.world(id)
    #       worlds[id]
    #     end
    #
    #     def self.add_world(world)
    #       worlds[world.id] = world
    #     end
    #
    #     def self.remove_world(world)
    #       worlds.delete(world.id)
    #     end
    #
    #     def self.clear
    #       worlds.clear
    #     end
    #
    #     def self.worlds
    #       @worlds ||= {}
    #     end
  end
end
