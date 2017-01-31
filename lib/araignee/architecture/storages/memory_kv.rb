module Araignee
  module Architecture
    module Storages
      # Key/Value memory storage for entities
      class MemoryKV
        attr_reader :entities

        def initialize
          @entities = {}
        end

        def configure(_config)
        end

        def exists?(filters)
          @entities.key?(filters[:id])
        end

        def one(filters)
          @entities[filters[:id]]
        end

        def many(_filters)
          # just returns everything
          @entities.map { |k, v| { k => v } }
        end

        def create(entity)
          @entities[entity[:id]] = entity

          true
        end

        def delete(filters)
          entity = @entities.delete(filters[:id])

          return 1 if entity
          0
        end
      end
    end
  end
end
