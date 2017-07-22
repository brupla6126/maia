#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'term'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # Class
      class TermListEmpty < Term
        def truth?(entity)
          list = get_list(entity)

          list.empty?
        end

        protected

        def get_list(entity)
        end
      end
    end
  end
end
