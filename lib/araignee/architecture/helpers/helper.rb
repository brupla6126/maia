require 'araignee/architecture/repository'
require 'araignee/architecture/helpers/creator'
require 'araignee/architecture/helpers/deleter'
require 'araignee/architecture/helpers/finder'
require 'araignee/architecture/helpers/updater'
require 'araignee/architecture/helpers/validator'

module Araignee
  module Architecture
    module Helpers
      # Base methods for helpers
      module Helper
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
end
