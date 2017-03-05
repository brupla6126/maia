module Araignee
  module Architecture
    module Storages
      # Table memory storage for entities
      class MemoryTable
        attr_reader :entities

        def initialize
          @entities = []
        end

        def configure(_config)
        end

        def exists?(filters)
          @entities.select { |entity| entity.id == filters[:id] }.any?
        end

        def one(filters)
          @entities.select { |entity| entity.id == filters[:id] }[0]
        end

        def many(_filters = {}, _sort = nil, _limit = nil)
          @entities
        end

        def create(entity)
          @entities << entity

          true
        end

        def update(entity)
          if @entities.select { |e| e.id == entity.id }.any?
            @entities.map! { |e| e.id == entity.id ? entity : e }
          else
            @entities << entity
          end

          true
        end

        def delete(filters)
          index = @entities.index { |entity| entity.id == filters[:id] }
          entity = @entities.delete_at(index) if index

          return 1 if entity
          0
        end
      end
    end
  end
end
