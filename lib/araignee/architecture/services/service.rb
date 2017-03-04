require 'araignee/architecture/repository'
require 'araignee/architecture/services/creator'
require 'araignee/architecture/services/deleter'
require 'araignee/architecture/services/finder'
require 'araignee/architecture/services/updater'
require 'araignee/architecture/services/validator'

module Araignee
  module Architecture
    # Base methods for services
    module Service
      protected

      def creator(klass)
        Repository.for(klass, :creator) || Creator.instance
      end

      def finder(klass)
        Repository.for(klass, :finder) || Finder.instance
      end

      def deleter(klass)
        Repository.for(klass, :deleter) || Deleter.instance
      end

      def storage(klass)
        Repository.for(klass, :storage)
      end

      def updater(klass)
        Repository.for(klass, :updater) || Updater.instance
      end

      def validator(klass)
        Repository.for(klass, :validator) || Validator.instance
      end
    end
  end
end
