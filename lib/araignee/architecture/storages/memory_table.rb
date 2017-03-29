module Araignee
  module Architecture
    module Storages
      # Table memory storage for entities
      class MemoryTable
        attr_reader :entities

        def initialize
          @entities = []
        end

        def exists?(filters)
          !one(filters).nil?
        end

        def one(filters)
          selected = []

          filters.each_key do |key|
            selected += @entities.select { |entity| entity.send(:"#{key}") == filters[key] }
          end

          selected.uniq.any? ? selected[0] : nil
        end

        def many(filters = {}, _sort = nil, _limit = nil)
          return @entities if filters.empty?

          selected = []

          filters.each_key do |key|
            selected += @entities.select { |entity| entity.send(:"#{key}") == filters[key] }
          end

          selected.uniq
        end

        def create(entity)
          entity.id = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten.shuffle[0, 16].join unless entity.id

          @entities << entity

          true
        end

        def update(entity)
          entity.id = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten.shuffle[0, 16].join unless entity.id

          if @entities.select { |e| e.id == entity.id }.any?
            @entities.map! { |e| e.id == entity.id ? entity : e }
          else
            @entities << entity
          end

          true
        end

        def delete(filters)
          index = @entities.index { |entity| entity.id == filters[:id] }
          index ? @entities.delete_at(index) : nil
        end

        def clear
          @entities.clear
        end
      end
    end
  end
end
