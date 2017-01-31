module Araignee
  module Architecture
    # Class for global access to objects
    class Repository
      def self.register(type, repository)
        repositories[type] = repository
      end

      def self.for(type)
        repositories[type]
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
