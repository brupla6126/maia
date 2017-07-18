require 'araignee/architecture/repository'
require 'araignee/architecture/helpers/validator'

module Araignee
  module Architecture
    module Helpers
      # Base methods for helpers
      module Helper
        protected

        def storage(klass)
          Repository.for(klass, :storage)
        end

        def validator(klass)
          Repository.for(klass, :validator) || Validator.instance
        end
      end
    end
  end
end
