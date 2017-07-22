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
      class TermListElement < Term
        def initialize(element)
          @element = element
        end

        def truth?(entity)
          list = get_list(entity)

          list.include? @element
        end

        protected

        def get_lista(entity)
        end
      end
    end
  end
end
