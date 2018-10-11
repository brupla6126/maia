require 'araignee/utils/emitter'
require 'artemisia/manager'

module Artemisia
  module Managers
    # To tag unique entities such as "player", "sun".
    class TagManager < Manager
      include Araignee::Utils::Emitter

      def initialize(attributes)
        attributes.type = :tag_manager
        super(attributes)

        @tags = {}
      end

      # entity_id String
      def add(tag, entity_id)
        # raise if tag already taken ???

        @tags[tag] = entity_id

        emit(:tag_added, tag, entity_id)

        self
      end

      def remove(tag)
        entity_id = @tags.delete(tag)

        emit(:tag_removed, tag, entity_id)

        self
      end

      def has?(tag)
        @tags.key?(tag)
      end

      def entity(tag)
        @tags[tag]
      end

      def tags
        @tags.keys
      end
    end
  end
end
