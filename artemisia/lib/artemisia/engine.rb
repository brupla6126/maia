require 'araignee/utils/emitter'

module Artemisia
  class Engine
    include Araignee::Utils::Emitter

    attr_reader :context, :worlds

    def initialize(context)
      @context = context
      @worlds = []
    end

    def boot
      load_initializers(@context.config.initializers_path)

      load_factories(@context.config.factories_paths)

      load_templates(@context.config.templates_paths)

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

    def load_initializers(path)
      require_files(File.join(path, '**', '*.rb'))
    end

    def load_factories(paths)
      paths.each do |path|
        require_files(File.join(path, '**', '*.rb'))
      end
    end

    def load_templates(paths)
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
