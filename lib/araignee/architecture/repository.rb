module Araignee
  module Architecture
    # Class for global access to repositories
    class Repository
      def self.register(type, repository)
        repositories[type] = repository
      end

      def self.for(type)
        repositories[type] || raise(ArgumentError, "repository :#{type} not registered")
      end

      def self.repositories
        @repos ||= {}
      end

      def self.clean
        @repos = {}
      end
    end
  end
end
